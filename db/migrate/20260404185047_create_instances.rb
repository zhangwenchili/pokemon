class CreateInstances < ActiveRecord::Migration[8.1]
  def change
    create_table :instances do |t|
      t.string :nickname
      t.integer :level
      t.references :user, null: false, foreign_key: true
      t.references :species, null: false, foreign_key: true

      t.timestamps
    end
  end
end
