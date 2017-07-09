source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.13'

# Use postgresql as the database for Active Record
gem 'pg', '0.20'

# Use bootstrap SASS for stylesheets
gem 'bootstrap-sass', '~> 3.3.6'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 3.2'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# ruby templating system for generating JSON, XML ...
gem 'rabl'

# HTTP 1.1 server for Ruby/Rack applications
gem 'puma'

# Upload files from Ruby applications
gem 'carrierwave', '~> 1.0'

# Process jobs in background
gem 'delayed_job_active_record'

gem 'time_difference'

group :development do
  gem 'pry-rails'
end

group :development,:test do

  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx] # link to better_errors

  gem 'quiet_assets' # quiet log message of assets

  gem 'factory_girl_rails', :require => false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'railroady'
  gem 'faker'

  gem 'simplecov', :require => false

end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
