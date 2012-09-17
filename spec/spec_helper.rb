require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

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
  # Prevent main application to eager_load in the prefork block (do not load files in autoload_paths)
  Spork.trap_method(Rails::Application, :eager_load!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)

  # Load all railties files
  Rails.application.railties.all { |r| r.eager_load! }
  require 'rspec/rails'
  require 'rspec/autorun'

  #case ENV["BROWSER"].to_s.downcase
  #  when 'firefox'
  #    # do nothing
  #  when 'phantomjs'
  #    require 'capybara/poltergeist'
  #  else
  #    require 'capybara/webkit'
  #end
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
    # Default driver is stil :rack_test because it's fast. Rspec will only run :webkit as a driver for JavaScript tests.
    # Add ":js => true" before the block in rspec tests to do this
    #case ENV["BROWSER"].to_s.downcase
    #  when 'firefox'
    #    Capybara.default_driver = :selenium
    #    Capybara.javascript_driver = :selenium
    #    Capybara.default_wait_time = 5
    #  when 'phantomjs'
    #    Capybara.default_driver = :poltergeist
    #    Capybara.javascript_driver = :poltergeist
    #  when 'webkit'
    #    Capybara.default_driver = :webkit
    #    Capybara.javascript_driver = :webkit
    #  else
    #    Capybara.javascript_driver = :webkit
    #end
    #config.filter_run_excluding :js => true if ENV["EXCLUDE_JS_SPECS"]

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
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