source "https://rubygems.org"

ruby "3.3.8"

gem "rails", "~> 7.1.5"
gem "sprockets-rails"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "kredis"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "tzinfo-data", platforms: %i[windows jruby]
gem 'mailtrap' # Used for Sending Emails


group :development, :test do
  gem "sqlite3", "~> 1.4"
end

group :production do
  gem "pg", "~> 1.5"
end
group :development do
  gem "web-console"
end

group :test do
  gem "simplecov", require: false
  gem "selenium-webdriver"
end

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "cucumber-rails", require: false
  gem "database_cleaner-active_record"
  gem "capybara"
  gem "rspec-expectations"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "dotenv-rails" 
end
