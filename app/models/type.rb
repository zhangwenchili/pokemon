class Type < ApplicationRecord
  has_many :species_type_maps, dependent: :destroy
  has_many :species, through: :species_type_maps
end
