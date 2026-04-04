class CreateSpeciesTypeMaps < ActiveRecord::Migration[8.1]
  def change
    create_table :species_type_maps do |t|
      t.references :species, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
