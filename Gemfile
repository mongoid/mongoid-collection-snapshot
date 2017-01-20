source 'http://rubygems.org'

gemspec

case version = ENV['MONGOID_VERSION'] || '6.0'
when /^6/
  gem 'mongoid', '~> 6.0'
when /^5/
  gem 'mongoid', '~> 5.0'
when /^4/
  gem 'mongoid', '~> 4.0'
when /^3/
  gem 'mongoid', '~> 3.1'
else
  gem 'mongoid', version
end

group :development, :test do
  gem 'mongoid-danger', '~> 0.1.1'
  gem 'rake'
  gem 'rspec', '~> 3.1'
  gem 'rubocop', '0.47.1'
  gem 'timecop'
end
