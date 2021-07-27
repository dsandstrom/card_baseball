class CreateRosters < ActiveRecord::Migration[6.1]
  def change
    create_table :rosters do |t|
      t.integer :team_id, null: false
      t.integer :player_id, null: false
      t.integer :level, null: false
      t.integer :position

      t.timestamps
    end

    add_index :rosters, :team_id
    add_index :rosters, :level
  end
end
