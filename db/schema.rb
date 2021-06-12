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

ActiveRecord::Schema.define(version: 2021_06_12_065216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hitter_contracts", force: :cascade do |t|
    t.integer "hitter_id", null: false
    t.integer "team_id"
    t.integer "length", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "short_stop_defense"
    t.integer "center_field_defense"
    t.integer "outfield_defense"
    t.integer "pitcher_defense"
    t.integer "catcher_bar"
    t.integer "pitcher_bar"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["last_name"], name: "index_hitters_on_last_name"
    t.index ["roster_name"], name: "index_hitters_on_roster_name", unique: true
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon"
    t.integer "league_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
