# frozen_string_literal: true

Fabricator(:hitter) do
  last_name { sequence(:hitters) { |n| "Hitter Last Name #{n + 1}" } }
  roster_name { |attrs| attrs[:last_name] }
  primary_position { rand(Hitter::POSITION_RANGE) }
  bats { Hitter::BATS_OPTIONS.sample }
  bunt_grade { Hitter::BUNT_GRADE_OPTIONS.sample }
  speed { rand(Hitter::SPEED_RANGE) }
  durability { rand(Hitter::RATING_RANGE) }
  overall_rating { rand(Hitter::RATING_RANGE) }
  left_rating { rand(Hitter::RATING_RANGE) }
  right_rating { rand(Hitter::RATING_RANGE) }
  left_on_base_percentage { rand(Hitter::RATING_RANGE) }
  right_on_base_percentage { rand(Hitter::RATING_RANGE) }
  left_slugging { rand(Hitter::RATING_RANGE) }
  right_slugging { rand(Hitter::RATING_RANGE) }
  left_homeruns { rand(Hitter::RATING_RANGE) }
  right_homeruns { rand(Hitter::RATING_RANGE) }
end
