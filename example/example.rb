$LOAD_PATH.unshift File.dirname(__FILE__)

require 'bundler/setup'
Bundler.require

require 'artist'
require 'artwork'

require 'artist_artwork_price'
require 'artist_artwork_price_mr'

Mongoid.configure do |config|
  config.connect_to('mongoid-collection-snapshot_example')
end

Mongoid.logger.level = Logger::INFO
Mongo::Logger.logger.level = Logger::INFO

Mongoid.purge!

3.times do
  Artist.create!(name: Faker::Name.name)
end

3.times do
  puts 'Creating more artworks ...'
  Artist.all.each do |artist|
    rand(10).times do
      Artwork.create!(
        artist: artist,
        title: Faker::Hipster.sentence,
        price: Faker::Number.between(1, 1000)
      )
    end
  end

  snapshot = ArtistArtworkPrice.create # AverageArtistPriceMR.create

  snapshot.documents.each do |row|
    puts "  the total price of #{row.count} artwork(s) by #{row.artist.name} is $#{row.sum}"
  end
end

Mongoid.purge!
