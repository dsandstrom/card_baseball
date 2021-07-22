# frozen_string_literal: true

Fabricator(:player) do
  last_name { sequence(:players) { |n| "Player Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position { rand(Player::POSITION_RANGE) }
  bats { Player::BATS_OPTIONS.sample }
  offensive_rating { rand(Player::RATING_RANGE) }

  after_build do |hitter|
    next unless hitter.primary_position

    primary_defense = "defense#{hitter.primary_position}"
    next if hitter.send(primary_defense).present?

    hitter.send("#{primary_defense}=", rand(Player::DEFENSE_RANGE).abs)
  end
end

Fabricator(:hitter, from: :player) do
  last_name { sequence(:players) { |n| "Hitter Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position { rand(2..8) }
  bunt_grade { Player::BUNT_GRADE_OPTIONS.sample }
  speed { rand(Player::SPEED_RANGE) }
  offensive_durability { rand(Player::RATING_RANGE) }
  left_hitting { rand(Player::RATING_RANGE) }
  right_hitting { rand(Player::RATING_RANGE) }
  left_on_base_percentage { rand(Player::RATING_RANGE) }
  right_on_base_percentage { rand(Player::RATING_RANGE) }
  left_slugging { rand(Player::RATING_RANGE) }
  right_slugging { rand(Player::RATING_RANGE) }
  left_homerun { rand(Player::RATING_RANGE) }
  right_homerun { rand(Player::RATING_RANGE) }
end

Fabricator(:pitcher, from: :player) do
  last_name { sequence(:players) { |n| "Pitcher Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position 1
  throws { Player::THROWS_OPTIONS.sample }
  bar1 { rand(-1..4) }
  pitcher_rating { rand(Player::RATING_RANGE) }
  pitching_durability { rand(Player::RATING_RANGE) }
  pitcher_type { Player::PITCHING_TYPES.keys.sample }
  starting_pitching { rand(Player::RATING_RANGE) }
  relief_pitching { rand(Player::RATING_RANGE) }
end

Fabricator(:hitting_pitcher, from: :hitter) do
  # last_name { sequence(:players) { |n| "Pitcher Last Name #{n + 1}" } }
  # roster_name { |attrs| attrs[:last_name] }
  primary_position 1
  throws { Player::THROWS_OPTIONS.sample }
  hitting_pitcher true
  bar1 { rand(-1..4) }
  pitcher_rating { rand(Player::RATING_RANGE) }
  pitching_durability { rand(Player::RATING_RANGE) }
  pitcher_type { Player::PITCHING_TYPES.keys.sample }
  starting_pitching { rand(Player::RATING_RANGE) }
  relief_pitching { rand(Player::RATING_RANGE) }
end
