# Pokédex entry: name, artwork URL, and many-to-many Types via SpeciesTypeMap.
class Species < ApplicationRecord
  has_many :instances, dependent: :restrict_with_error
  has_many :species_type_maps, dependent: :destroy
  has_many :types, through: :species_type_maps

  # Comma-separated type labels for cards and detail pages (matches PokéAPI slot order).
  def type_names_csv
    species_type_maps.includes(:type).order(:id).map { |m| m.type.name.humanize }.join(", ")
  end
end
