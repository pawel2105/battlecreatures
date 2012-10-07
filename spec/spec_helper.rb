require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  if ENV['HEADLESS']
    require 'headless'
  end

  if (ENV['COVERAGE'] == 'on')
    require 'simplecov'
    require 'simplecov-rcov'
    class SimpleCov::Formatter::MergedFormatter
      def format(result)
        SimpleCov::Formatter::HTMLFormatter.new.format(result)
        SimpleCov::Formatter::RcovFormatter.new.format(result)
      end
    end
    SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
    SimpleCov.start 'rails' do
      add_filter "/vendor/"
    end
  end

  require "rails/application"

  Spork.trap_method(Rails::Application, :eager_load!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)

  Rails.application.railties.all { |r| r.eager_load! }
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'webmock/rspec'

end

Spork.each_run do
  def in_memory_database?
    Rails.configuration.database_configuration[ENV["RAILS_ENV"]]['database'] == ':memory:'
  end

  if in_memory_database?
    load "#{Rails.root}/db/schema.rb"
    ActiveRecord::Migrator.up('db/migrate') # then run migrations
  end
  FactoryGirl.reload
  DatabaseCleaner.clean_with :truncation

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.order = "random"
    config.before(:suite) do
      if ENV["BROWSER"]
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      (@@headless = Headless.new).start if ENV['HEADLESS']
    end

    config.after(:suite) do
      @@headless.destroy if ENV['HEADLESS']
    end

    config.before(:all, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.after(:all, :js => true) do
      if ENV["BROWSER"]
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

end