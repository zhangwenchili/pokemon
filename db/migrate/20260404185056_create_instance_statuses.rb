class CreateInstanceStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :instance_statuses do |t|
      t.integer :hit_point
      t.references :instance, null: false, foreign_key: true

      t.timestamps
    end

    add_index :instance_statuses, :instance_id, unique: true
  end
end
