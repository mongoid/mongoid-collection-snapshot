source 'https://rubygems.org'

gemspec

version = ENV['MONGOID_VERSION'] || '9'
gem 'bigdecimal' if RUBY_VERSION >= '3.4'
gem 'logger' if RUBY_VERSION >= '3.4'
gem 'mongoid', version =~ /\A\d+\z/ ? "~> #{version}.0" : version

group :development, :test do
  gem 'mongoid-danger', '~> 0.1.1'
  gem 'rake'
  gem 'rspec', '~> 3.1'
  gem 'rubocop', '0.47.1'
  gem 'simplecov', '~> 0.22' if ENV['COVERAGE'] == 'true'
  gem 'timecop'
end
