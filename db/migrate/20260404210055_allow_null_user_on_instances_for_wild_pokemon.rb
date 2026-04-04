class AllowNullUserOnInstancesForWildPokemon < ActiveRecord::Migration[8.1]
  def change
    change_column_null :instances, :user_id, true
  end
end
