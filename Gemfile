source "https://gems.ruby-china.com/"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem 'aws-sdk-s3', '~> 1.0'
gem 'image_processing', '~> 1.2'
gem 'dotenv-rails'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "solidus", "~> 4.5"

gem "solidus_auth_devise", "~> 2.5"
gem "responders"
gem "solidus_support", ">= 0.12.0"
gem "view_component", "~> 3.0"
gem "tailwindcss-rails", "~> 3.0"

group :test do
  gem "capybara-screenshot", "~> 1.0"
  gem "database_cleaner", "~> 2.0"
end

group :development, :test do
  gem "rspec-rails"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "rspec-activemodel-mocks", "~> 1.1.0"
  gem "factory_bot", ">= 4.8"
  gem "factory_bot_rails"
  gem "ffaker", "~> 2.13"
  gem "rubocop", "~> 1.0"
  gem "rubocop-performance", "~> 1.5"
  gem "rubocop-rails", "~> 2.3"
  gem "rubocop-rspec", "~> 2.0"
end

gem "solidus_admin", ">= 0.2"
