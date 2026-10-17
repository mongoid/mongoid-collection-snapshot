require 'spec_helper'

describe Mongoid::CollectionSnapshot do
  it 'defines a semantic version from the standalone version entry point' do
    hide_const('Mongoid::CollectionSnapshot::VERSION')
    begin
      load File.expand_path('../lib/mongoid-collection-snapshot/version.rb', __dir__)

      expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
      expect(described_class::VERSION).to be_frozen
    ensure
      described_class.send(:remove_const, :VERSION) if described_class.const_defined?(:VERSION)
    end
  end
end
