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

ActiveRecord::Schema.define(version: 2021_08_02_235234) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.integer "player_id", null: false
    t.integer "team_id"
    t.integer "length", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_contracts_on_team_id"
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
    t.string "throws"
    t.index ["last_name"], name: "index_players_on_last_name"
    t.index ["pitcher_type"], name: "index_players_on_pitcher_type"
    t.index ["primary_position"], name: "index_players_on_primary_position"
    t.index ["roster_name"], name: "index_players_on_roster_name", unique: true
  end

  create_table "rosters", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "player_id", null: false
    t.integer "level", null: false
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "row_order"
    t.index ["level"], name: "index_rosters_on_level"
    t.index ["team_id"], name: "index_rosters_on_team_id"
  end

  create_table "spots", force: :cascade do |t|
    t.integer "lineup_id", null: false
    t.integer "position", null: false
    t.integer "batting_order", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "hitter_id", null: false
    t.index ["lineup_id"], name: "index_spots_on_lineup_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.integer "league_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "logo"
    t.string "identifier", null: false
    t.integer "user_id"
    t.index ["identifier"], name: "index_teams_on_identifier", unique: true
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin_role", default: false
    t.string "city"
    t.string "time_zone", default: "UTC", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
