class CreateTeams < ActiveRecord::Migration[6.1]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :icon
      t.integer :league_id, null: false

      t.timestamps
    end
  end
end
