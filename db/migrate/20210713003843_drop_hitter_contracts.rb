class DropHitterContracts < ActiveRecord::Migration[6.1]
  def change
    drop_table :hitter_contracts do |t|
      t.integer :hitter_id, null: false
      t.integer :team_id
      t.integer :length, null: false

      t.timestamps
    end
  end
end
