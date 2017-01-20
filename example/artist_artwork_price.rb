class ArtistArtworkPrice
  include Mongoid::CollectionSnapshot

  document do
    field :count, type: Integer
    field :sum, type: Integer
    belongs_to :artist, inverse_of: nil
  end

  def build
    Artist.all.each do |artist|
      collection_snapshot.insert_one(
        artist_id: artist.id,
        count: artist.artworks.count,
        sum: artist.artworks.sum(&:price)
      )
    end
  end
end
