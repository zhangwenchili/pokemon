class AddFieldsToSpecies < ActiveRecord::Migration[8.1]
  def change
    add_column :species, :pokedex_number, :integer
    add_column :species, :image_url, :string
  end
end
