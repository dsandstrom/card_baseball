class DropHitters < ActiveRecord::Migration[6.1]
  def change
    drop_table :hitters do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name, null: false
      t.string :roster_name, null: false
      t.string :bats, null: false
      t.string :bunt_grade, null: false
      t.integer :speed, null: false
      t.integer :durability, null: false
      t.integer :overall_rating, null: false
      t.integer :left_rating, null: false
      t.integer :right_rating, null: false
      t.integer :left_on_base_percentage, null: false
      t.integer :left_slugging, null: false
      t.integer :left_homeruns, null: false
      t.integer :right_on_base_percentage, null: false
      t.integer :right_slugging, null: false
      t.integer :right_homeruns, null: false
      t.integer :catcher_defense
      t.integer :first_base_defense
      t.integer :second_base_defense
      t.integer :third_base_defense
      t.integer :shortstop_defense
      t.integer :center_field_defense
      t.integer :outfield_defense
      t.integer :pitcher_defense
      t.integer :catcher_bar, default: 0
      t.integer :pitcher_bar, default: 0

      t.timestamps
    end
  end
end
