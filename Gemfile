source 'https://rubygems.org'

ruby '3.0.0'

gem 'pg', '~> 1.3'
gem 'rack-test', '~> 1.1'
gem 'sinatra', '~> 2.2'
gem 'webrick', '~> 1.7'
gem 'sinatra-contrib', '~> 2.2'

group :test do
  gem 'rspec', '~> 3.11'
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
end

group :development, :test do
  gem 'rubocop', '1.20'
end
