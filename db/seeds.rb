# frozen_string_literal: true

require 'faker'

class Seeds
  def add_hitters(quanity = 10)
    quanity.times do
      hitter = Hitter.new(hitter_attrs)
      hitter.set_roster_name
      hitter.save
    end
  end

  private

    def hitter_attrs
      attrs = {}
      attrs[:first_name] = Faker::Name.male_first_name
      attrs[:middle_name] = Faker::Name.middle_name if rand(10).zero?
      attrs[:last_name] = Faker::Name.last_name
      attrs[:primary_position] = rand(Hitter::POSITION_RANGE)
      attrs[:bats] = Hitter::BATS_OPTIONS.sample
      attrs[:bunt_grade] = Hitter::BUNT_GRADE_OPTIONS.sample
      attrs[:speed] = rand(Hitter::SPEED_RANGE)
      attrs[:durability] = rand(Hitter::RATING_RANGE)
      attrs[:overall_rating] = rand(Hitter::RATING_RANGE)
      attrs[:left_rating] = rand(Hitter::RATING_RANGE)
      attrs[:right_rating] = rand(Hitter::RATING_RANGE)
      attrs[:left_on_base_percentage] = rand(Hitter::RATING_RANGE)
      attrs[:right_on_base_percentage] = rand(Hitter::RATING_RANGE)
      attrs[:left_slugging] = rand(Hitter::RATING_RANGE)
      attrs[:right_slugging] = rand(Hitter::RATING_RANGE)
      attrs[:left_homeruns] = rand(Hitter::RATING_RANGE)
      attrs[:right_homeruns] = rand(Hitter::RATING_RANGE)
      attrs
    end
end

seeds = Seeds.new
seeds.add_hitters
