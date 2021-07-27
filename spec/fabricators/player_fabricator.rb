# frozen_string_literal: true

Fabricator(:player) do
  last_name { sequence(:players) { |n| "Player Last Name #{n + 1}" } }
  primary_position { rand(Player::POSITION_RANGE) }
  bats { Player::BATS_MAP.keys.sample }
  offensive_rating { rand(Player::RATING_RANGE) }

  after_build do |player|
    player.set_roster_name
    next unless player.primary_position

    primary_defense = "defense#{player.primary_position}"
    next if player.send(primary_defense).present?

    player.send("#{primary_defense}=", rand(Player::DEFENSE_RANGE).abs)
  end
end

Fabricator(:hitter, from: :player) do
  last_name { sequence(:players) { |n| "Hitter Last Name #{n + 1}" } }
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
  primary_position 1
  throws { Player::THROWS_MAP.keys.sample }
  bar1 { rand(-1..4) }
  pitcher_rating { rand(Player::RATING_RANGE) }
  pitching_durability { rand(Player::RATING_RANGE) }
  pitcher_type { Player::PITCHER_TYPES.keys.sample }
  starting_pitching { rand(Player::RATING_RANGE) }
  relief_pitching { rand(Player::RATING_RANGE) }
end

Fabricator(:hitting_pitcher, from: :hitter) do
  primary_position 1
  throws { Player::THROWS_MAP.keys.sample }
  hitting_pitcher true
  bar1 { rand(-1..4) }
  pitcher_rating { rand(Player::RATING_RANGE) }
  pitching_durability { rand(Player::RATING_RANGE) }
  pitcher_type { Player::PITCHER_TYPES.keys.sample }
  starting_pitching { rand(Player::RATING_RANGE) }
  relief_pitching { rand(Player::RATING_RANGE) }
  defense7 { rand(Player::DEFENSE_RANGE) }
end

Fabricator(:starting_pitcher, from: :pitcher) do
  pitcher_type 'S'
  starting_pitching { rand(Player::RATING_RANGE) }
end

Fabricator(:relief_pitcher, from: :pitcher) do
  pitcher_type 'R'
  relief_pitching { rand(Player::RATING_RANGE) }
end
