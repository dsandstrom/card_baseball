class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.integer :player_id, null: false
      t.integer :team_id
      t.integer :length, null: false

      t.timestamps
    end

    add_index :contracts, :team_id
  end
end
