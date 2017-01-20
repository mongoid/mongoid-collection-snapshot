class Artist
  include Mongoid::Document

  field :name, type: String
  has_many :artworks
end
