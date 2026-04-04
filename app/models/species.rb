class Species < ApplicationRecord
  has_many :instances
  has_many :species_type_maps
  has_many :types, through: :species_type_maps
end
