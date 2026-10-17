require 'spec_helper'

describe Mongoid::CollectionSnapshot do
  it 'defines a frozen semantic version' do
    expect(described_class::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
    expect(described_class::VERSION).to be_frozen
  end
end
