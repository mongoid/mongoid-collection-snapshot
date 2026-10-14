if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    track_files 'lib/**/*.rb'
    add_filter '/spec/'
  end
end

require 'rubygems'
require 'bundler/setup'
require 'rspec'

require 'mongoid'
require 'timecop'

config_version = [Mongoid::VERSION.to_i, 6].min
Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid#{config_version}.yml", :test)

require File.expand_path('../../lib/mongoid-collection-snapshot', __FILE__)
Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }

require 'mongoid-compatibility'

RSpec.configure do |c|
  c.before(:all) do
    Mongoid.logger.level = Logger::INFO
    Mongo::Logger.logger.level = Logger::INFO if Mongoid::VERSION.to_i >= 5
  end
  c.before(:each) do
    Mongoid.purge!
  end
  c.after(:all) do
    if Mongoid::VERSION.to_i >= 5
      Mongoid.default_client.database.drop
    else
      Mongoid.default_session.drop
    end
  end
end

RSpec.configure(&:raise_errors_for_deprecations!)
