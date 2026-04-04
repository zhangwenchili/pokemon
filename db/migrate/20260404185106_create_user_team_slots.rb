class CreateUserTeamSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :user_team_slots do |t|
      t.references :user, null: false, foreign_key: true
      t.references :instance, null: false, foreign_key: true
      t.integer :slot_index

      t.timestamps
    end
  end
end
