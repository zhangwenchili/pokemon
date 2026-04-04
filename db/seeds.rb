# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).


require "net/http"
require "json"

puts "Clearing old data..."
UserTeamSlot.destroy_all
InstanceStatus.destroy_all
Instance.destroy_all
SpeciesTypeMap.destroy_all
Type.destroy_all
Species.destroy_all

(1..386).each do |id|
  puts "Fetching species ##{id}..."

  species_url = URI("https://pokeapi.co/api/v2/pokemon-species/#{id}/")
  pokemon_url = URI("https://pokeapi.co/api/v2/pokemon/#{id}/")

  species_response = JSON.parse(Net::HTTP.get(species_url))
  pokemon_response = JSON.parse(Net::HTTP.get(pokemon_url))

  # name
  english_name =
    species_response["names"]
      .find { |n| n.dig("language", "name") == "en" }
      &.dig("name") || species_response["name"]

  # image
  image_url =
    pokemon_response.dig("sprites", "other", "official-artwork", "front_default") ||
    pokemon_response.dig("sprites", "front_default")

  # create species
  species = Species.create!(
    name: english_name,
    pokedex_number: id,
    image_url: image_url
  )

  # handle types
  pokemon_response["types"].each do |type_entry|
    type_name = type_entry.dig("type", "name")

    type = Type.find_or_create_by!(name: type_name)

    SpeciesTypeMap.create!(
      species: species,
      type: type
    )
  end
end

puts "Creating wild Pokémon instances..."
Species.order(:pokedex_number).limit(40).find_each do |sp|
  inst = Instance.create!(
    user: nil,
    species: sp,
    nickname: sp.name,
    level: rand(5..45)
  )
  InstanceStatus.create!(
    instance: inst,
    hit_point: rand(25..100)
  )
end

puts "Done! Seeded species, types, relationships, and wild instances."
