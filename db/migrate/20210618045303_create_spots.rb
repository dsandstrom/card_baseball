class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.integer :lineup_id, null: false
      t.integer :hitter_id, null: false
      t.integer :position, null: false
      t.integer :batting_order, null: false

      t.timestamps
    end

    add_index :spots, :lineup_id
    add_index :hitter_contracts, :team_id
    add_index :lineups, :team_id
  end
end
