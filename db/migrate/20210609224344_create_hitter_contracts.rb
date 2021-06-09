class CreateHitterContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :hitter_contracts do |t|
      t.integer :hitter_id, null: false
      t.integer :team_id, null: false
      t.integer :length, null: false

      t.timestamps
    end
  end
end
