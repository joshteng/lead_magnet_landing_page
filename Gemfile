source 'https://rubygems.org'

ruby '2.1.0'

gem 'rails', '4.0.4'
gem 'sass-rails', '~> 4.0.1'
gem 'uglifier', '~> 2.5.0'
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails', '~> 3.1.0'
gem 'jbuilder', '~> 1.5.3'
gem 'bcrypt'
gem 'pg'
gem 'clearance', git: "https://github.com/thoughtbot/clearance.git"
gem 'sucker_punch', '~> 1.0'
gem 'slim-rails'
gem 'simple_form'
gem 'cocoon'
gem 'kaminari', '~> 0.15.0' # Paging
gem 'friendly_id', '~> 5.0.2' # Slugs and friendly id's
gem 'font-awesome-sass', '~> 4.0.2' # font-awesome
gem 'bootstrap-sass', '~> 3.1.1.0'
gem 'mailchimp-api', require: 'mailchimp'

gem 'unicorn', require: false
gem 'figaro', '~> 0.7.0'     # env variables

group :development do
  gem 'annotate', require: false
  gem 'guard-rspec', require: false
  gem 'growl', require: false
  gem 'debugger'
  gem 'letter_opener'
end

group :test, :development do
  gem 'rails_layout', '~> 0.5.11'  # Bootstrap 3 layout generator
  gem 'awesome_print'
  gem "rspec-rails", '~> 2.14.1'
  gem "factory_girl_rails"
  gem "faker", require: false
end

group :test do
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver", "2.41.0"
  gem "capybara", '~> 2.2.1'
  gem 'simplecov'
  gem "codeclimate-test-reporter"
  gem 'email_spec'
  gem 'action_mailer_cache_delivery'
  gem 'zeus'
end

group :doc do
  gem 'sdoc', require: false
end
