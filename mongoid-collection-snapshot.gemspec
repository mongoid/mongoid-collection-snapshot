$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'mongoid-collection-snapshot/version'

Gem::Specification.new do |s|
  s.name = 'mongoid-collection-snapshot'
  s.version = Mongoid::CollectionSnapshot::VERSION
  s.authors = ['Aaron Windsor']
  s.email = 'aaron.windsor@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/mongoid/mongoid-collection-snapshot'
  s.licenses = ['MIT']
  s.summary = 'Easy maintenence of collections of processed data in MongoDB with the Mongoid ODM.'
  s.add_dependency 'mongoid', '>= 3.0'
  s.add_dependency 'mongoid-compatibility'
  s.add_dependency 'mongoid-slug'
end
