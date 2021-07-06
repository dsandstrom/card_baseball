class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :nick_name
      t.string :last_name, null: false
      t.string :roster_name, null: false
      t.string :bats, null: false
      t.integer :speed, default: 0
      t.string :bunt_grade, default: 'B'
      t.integer :primary_position, null: false
      t.integer :offensive_rating
      t.integer :left_hitting, default: 0
      t.integer :right_hitting, default: 0
      t.integer :left_on_base_percentage, default: 0
      t.integer :right_on_base_percentage, default: 0
      t.integer :left_slugging, default: 0
      t.integer :right_slugging, default: 0
      t.integer :left_homerun, default: 0
      t.integer :right_homerun, default: 0
      t.integer :offensive_durability
      t.integer :pitcher_rating
      t.string :pitcher_type
      t.integer :starting_pitching
      t.integer :relief_pitching
      t.integer :pitching_durability
      t.boolean :hitting_pitcher, default: false
      t.integer :bar1, default: 0
      t.integer :bar2, default: 0
      t.integer :defense1
      t.integer :defense2
      t.integer :defense3
      t.integer :defense4
      t.integer :defense5
      t.integer :defense6
      t.integer :defense7
      t.integer :defense8

      t.timestamps
    end

    add_index :players, :last_name
    add_index :players, :primary_position
    add_index :players, :roster_name, unique: true
    add_index :players, :pitcher_type
  end
end
