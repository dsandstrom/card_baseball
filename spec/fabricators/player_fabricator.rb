# frozen_string_literal: true

# TODO: set defense from primary_position

Fabricator(:player) do
  last_name { sequence(:players) { |n| "Player Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position { rand(Player::POSITION_RANGE) }
  bats { Player::BATS_OPTIONS.sample }
  offensive_rating { rand(Player::RATING_RANGE) }
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
  defense1 { rand(0..4) }
end
