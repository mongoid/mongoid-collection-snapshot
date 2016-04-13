class Artwork
  include Mongoid::Document

  field :name
  field :price

  belongs_to :artist
  belongs_to :partner
end
