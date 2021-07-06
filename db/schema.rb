# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_05_045648) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hitter_contracts", force: :cascade do |t|
    t.integer "hitter_id", null: false
    t.integer "team_id"
    t.integer "length", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_hitter_contracts_on_team_id"
  end

  create_table "hitters", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "roster_name", null: false
    t.string "bats", null: false
    t.string "bunt_grade", null: false
    t.integer "speed", null: false
    t.integer "durability", null: false
    t.integer "overall_rating", null: false
    t.integer "left_rating", null: false
    t.integer "right_rating", null: false
    t.integer "left_on_base_percentage", null: false
    t.integer "left_slugging", null: false
    t.integer "left_homeruns", null: false
    t.integer "right_on_base_percentage", null: false
    t.integer "right_slugging", null: false
    t.integer "right_homeruns", null: false
    t.integer "catcher_defense"
    t.integer "first_base_defense"
    t.integer "second_base_defense"
    t.integer "third_base_defense"
    t.integer "center_field_defense"
    t.integer "outfield_defense"
    t.integer "pitcher_defense"
    t.integer "catcher_bar"
    t.integer "pitcher_bar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "primary_position", null: false
    t.boolean "hitting_pitcher", default: false
    t.integer "shortstop_defense"
    t.index ["last_name"], name: "index_hitters_on_last_name"
    t.index ["primary_position"], name: "index_hitters_on_primary_position"
    t.index ["roster_name"], name: "index_hitters_on_roster_name", unique: true
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "row_order"
  end

  create_table "lineups", force: :cascade do |t|
    t.integer "team_id", null: false
    t.string "name"
    t.string "vs"
    t.boolean "with_dh", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_lineups_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "nick_name"
    t.string "last_name", null: false
    t.string "roster_name", null: false
    t.string "bats", null: false
    t.integer "speed", default: 0
    t.string "bunt_grade", default: "B"
    t.integer "primary_position", null: false
    t.integer "offensive_rating"
    t.integer "left_hitting", default: 0
    t.integer "right_hitting", default: 0
    t.integer "left_on_base_percentage", default: 0
    t.integer "right_on_base_percentage", default: 0
    t.integer "left_slugging", default: 0
    t.integer "right_slugging", default: 0
    t.integer "left_homerun", default: 0
    t.integer "right_homerun", default: 0
    t.integer "offensive_durability"
    t.integer "pitcher_rating"
    t.string "pitcher_type"
    t.integer "starting_pitching"
    t.integer "relief_pitching"
    t.integer "pitching_durability"
    t.boolean "hitting_pitcher", default: false
    t.integer "bar1", default: 0
    t.integer "bar2", default: 0
    t.integer "defense1"
    t.integer "defense2"
    t.integer "defense3"
    t.integer "defense4"
    t.integer "defense5"
    t.integer "defense6"
    t.integer "defense7"
    t.integer "defense8"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["last_name"], name: "index_players_on_last_name"
    t.index ["pitcher_type"], name: "index_players_on_pitcher_type"
    t.index ["primary_position"], name: "index_players_on_primary_position"
    t.index ["roster_name"], name: "index_players_on_roster_name", unique: true
  end

  create_table "spots", force: :cascade do |t|
    t.integer "lineup_id", null: false
    t.integer "hitter_id", null: false
    t.integer "position", null: false
    t.integer "batting_order", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lineup_id"], name: "index_spots_on_lineup_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.integer "league_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo"
  end

end
