source 'https://rubygems.org'

gem 'rails', '~> 3.2.1'

gem 'pg'
gem 'newrelic_rpm'
gem 'thin'
gem 'cancan'
gem 'omniauth'
# gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
#  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'annotate'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'flog'
  gem "spork-rails"
end
