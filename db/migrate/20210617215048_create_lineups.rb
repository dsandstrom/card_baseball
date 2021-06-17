class CreateLineups < ActiveRecord::Migration[6.1]
  def change
    create_table :lineups do |t|
      t.integer :team_id, null: false
      t.string :name, null: false
      t.string :vs
      t.boolean :with_dh, default: false

      t.timestamps
    end
  end
end
