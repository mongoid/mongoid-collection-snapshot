require 'rubygems'
require 'bundler/setup'
require 'rspec'

require 'mongoid'
require 'timecop'

Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid#{ENV['MONGOID_VERSION'] || 7}.yml", :test)

require File.expand_path('../../lib/mongoid-collection-snapshot', __FILE__)
Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each { |f| require f }

require 'mongoid-compatibility'

RSpec.configure do |c|
  c.before(:all) do
    Mongoid.logger.level = Logger::INFO
    Mongo::Logger.logger.level = Logger::INFO if Mongoid::Compatibility::Version.mongoid5_or_newer?
  end
  c.before(:each) do
    Mongoid.purge!
  end
  c.after(:all) do
    if Mongoid::Compatibility::Version.mongoid5_or_newer?
      Mongoid.default_client.database.drop
    else
      Mongoid.default_session.drop
    end
  end
end

RSpec.configure(&:raise_errors_for_deprecations!)
