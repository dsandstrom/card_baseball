# frozen_string_literal: true

Fabricator(:player) do
  last_name { sequence(:hitters) { |n| "Player Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position { rand(Player::POSITION_RANGE) }
  bats { Player::BATS_OPTIONS.sample }
  bunt_grade { Player::BUNT_GRADE_OPTIONS.sample }
  speed { rand(Player::SPEED_RANGE) }
  offensive_durability { rand(Player::RATING_RANGE) }
  offensive_rating { rand(Player::RATING_RANGE) }
  left_hitting { rand(Player::RATING_RANGE) }
  right_hitting { rand(Player::RATING_RANGE) }
  left_on_base_percentage { rand(Player::RATING_RANGE) }
  right_on_base_percentage { rand(Player::RATING_RANGE) }
  left_slugging { rand(Player::RATING_RANGE) }
  right_slugging { rand(Player::RATING_RANGE) }
  left_homerun { rand(Player::RATING_RANGE) }
  right_homerun { rand(Player::RATING_RANGE) }
end
