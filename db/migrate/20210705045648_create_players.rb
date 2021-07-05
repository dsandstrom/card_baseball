class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :nick_name
      t.string :last_name, null: false
      t.string :roster_name, null: false
      t.string :bats, null: false
      t.string :bunt_grade, default: 'B'
      t.integer :speed, default: 0
      t.integer :hitting_durability
      t.integer :hitting_rating, default: 0
      t.integer :left_hitting_rating, default: 0
      t.integer :right_hitting_rating, default: 0
      t.integer :left_on_base_percentage, default: 0
      t.integer :right_on_base_percentage, default: 0
      t.integer :left_slugging, default: 0
      t.integer :right_slugging, default: 0
      t.integer :left_homerun, default: 0
      t.integer :right_homerun, default: 0
      t.boolean :hitting_pitcher, default: false
      t.integer :primary_position, null: false
      t.integer :bar_1, default: 0
      t.integer :bar_2, default: 0
      t.integer :defense_1
      t.integer :defense_2
      t.integer :defense_3
      t.integer :defense_4
      t.integer :defense_5
      t.integer :defense_6
      t.integer :defense_7
      t.integer :defense_8

      t.timestamps
    end

    add_index :players, :last_name
    add_index :players, :primary_position
    add_index :players, :roster_name, unique: true
  end
end
