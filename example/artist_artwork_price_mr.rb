class AverageArtistPriceMR
  include Mongoid::CollectionSnapshot

  document do
    field :count, type: Integer
    field :sum, type: Integer
    belongs_to :artist, inverse_of: nil
  end

  def build
    map = <<-EOS
      function() {
        emit({ artist_id: this['artist_id']}, { count: 1, sum: this['price'] })
      }
    EOS

    reduce = <<-EOS
      function(key, values) {
        var sum = 0;
        var count = 0;
        values.forEach(function(value) {
          sum += value['sum'];
          count += value['count'];
        });
        return({ count: count, sum: sum });
      }
    EOS

    Artwork.map_reduce(map, reduce).out(inline: 1).each do |doc|
      collection_snapshot.insert_one(
        artist_id: doc['_id']['artist_id'],
        count: doc['value']['count'],
        sum: doc['value']['sum']
      )
    end
  end
end
