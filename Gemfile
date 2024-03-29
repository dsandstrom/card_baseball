# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '6.0.0.rc.6'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# user authorization
gem 'cancancan', '~> 3.3'
# user authentication
gem 'devise', '~> 4.8'

# Pagination
# https://github.com/kaminari/kaminari
gem 'kaminari', '~> 1.2'

# Ordering
# https://github.com/brendon/ranked-model
gem 'ranked-model', '~> 0.4'

gem 'rollbar', '~> 3.2'

# required for ruby 3.1 until a new map version is released
gem 'net-imap', '~> 0.2.3', require: false
gem 'net-pop', '~> 0.1.1', require: false
# required for ruby 3.1
gem 'net-smtp', '~> 0.3.1', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.7'
  gem 'fabrication', '~> 2.22'
  gem 'faker', '~> 2.18', require: false
  gem 'guard', '~> 2.0'
  gem 'guard-bundler', require: false
  gem 'guard-rails', '~> 0.8.1', require: false
  gem 'guard-rspec', '~> 4.7.3', require: false
  gem 'rspec-rails', '~> 4.1'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'guard-webpacker', '~> 0.2.1'
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each
  # request in your browser.
  # Can be configured to work on production as well see:
  # https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 1.36.0', require: false
  gem 'scss_lint', '~> 0.59', require: false
  # gem 'scss_lint_reporter_junit', '~> 0.1', require: false
  gem 'spring', '~> 2.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  # for circleci support
  # gem 'rspec_junit_formatter', '~> 0.4.1'
  gem 'shoulda-matchers', '~> 4.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
