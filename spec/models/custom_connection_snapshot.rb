class CustomConnectionSnapshot
  include Mongoid::CollectionSnapshot

  def self.snapshot_session
    @snapshot_session ||= new_snapshot_session
  end

  def snapshot_session
    self.class.snapshot_session
  end

  def build
    if Mongoid::Compatibility::Version.mongoid5_or_newer?
      collection_snapshot.insert_one('name' => 'foo')
      collection_snapshot('foo').insert_one('name' => 'bar')
    else
      collection_snapshot.insert('name' => 'foo')
      collection_snapshot('foo').insert('name' => 'bar')
    end
  end

  private

  def self.new_snapshot_session
    if Mongoid::Compatibility::Version.mongoid5_or_newer?
      Mongo::Client.new('mongodb://localhost:27017/snapshot_test')
    else
      Moped::Session.new(['127.0.0.1:27017']).tap do |session|
        session.use :snapshot_test
      end
    end
  end
end
