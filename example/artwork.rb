class Artwork
  include Mongoid::Document

  field :title, type: String
  field :price, type: Integer

  belongs_to :artist
end
