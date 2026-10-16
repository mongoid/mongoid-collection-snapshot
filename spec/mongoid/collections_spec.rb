require 'spec_helper'

describe 'Snapshot collection discovery' do
  def insert(collection)
    if Mongoid::VERSION.to_i >= 5
      collection.insert_one('value' => 1)
    else
      collection.insert('value' => 1)
    end
  end

  it 'discovers named collections without generating document classes' do
    snapshot = MultiCollectionSnapshot.create!
    expect(snapshot).not_to receive(:documents)
    expected = %w(foo bar baz).map { |name| snapshot.collection_snapshot(name).name }
    expect(snapshot.collections.map(&:name)).to match_array(expected)
    expect(snapshot.collections.map { |collection| collection.find.first['name'] }).to match_array(%w(foo! bar! baz!))
  end

  it 'excludes other snapshots, unrelated collections and absent collections' do
    previous = MultiCollectionSnapshot.create!
    snapshot = MultiCollectionSnapshot.create!
    insert(snapshot.snapshot_session["#{snapshot.collection.name}.foo.#{snapshot.slug}.extra"])
    expect(snapshot.collections.map(&:name)).not_to include(previous.collection_snapshot('foo').name)
    expect(snapshot.collections.map(&:name)).not_to include(snapshot.collection_snapshot.name)
    expect(snapshot.collections.size).to eq(3)
  end

  it 'returns no collections before any data has been written' do
    expect(MultiCollectionSnapshot.new.collections).to be_empty
  end

  it 'matches literal collection names and slugs during discovery and cleanup' do
    snapshot = MultiCollectionSnapshot.new
    allow(snapshot.collection).to receive(:name).and_return('literal.snapshots')
    allow(snapshot).to receive(:slug).and_return('snapshot-1+')
    owned = snapshot.collection_snapshot('foo')
    unrelated = snapshot.snapshot_session['literalXsnapshots.foo.snapshot-11']
    insert(owned)
    insert(unrelated)
    expect(snapshot.collections.map(&:name)).to eq([owned.name])
    snapshot.drop_snapshot_collections
    expect(unrelated.find.count).to eq(1)
    expect(snapshot.collections).to be_empty
  end

  it 'discovers both unnamed and named collections in a custom database' do
    snapshot = CustomConnectionSnapshot.create!
    begin
      expected = [snapshot.collection_snapshot.name, snapshot.collection_snapshot('foo').name]
      expect(snapshot.collections.map(&:name)).to match_array(expected)
      expect(snapshot.collections.map { |collection| collection.find.first['name'] }).to match_array(%w(foo bar))
      snapshot.drop_snapshot_collections
      expect(snapshot.collections).to be_empty
    ensure
      snapshot.drop_snapshot_collections
    end
  end
end
