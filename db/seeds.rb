# frozen_string_literal: true

# TODO: add defense to hitters

require 'faker'

class Seeds
  def add_hitters(team: nil, quanity: 2, position: nil)
    quanity.times do
      return if team && team.hitters.count >= 15

      attrs = hitter_attrs(position)
      hitter = Hitter.new(attrs)
      hitter.set_roster_name
      hitter.save

      add_hitter_contract(hitter, team)
    end
  end

  def add_teams(league_quantity: 4, team_quantity: 5)
    league_quantity.times do
      league = League.create!(name: Faker::Compass.unique.direction.titleize)

      team_quantity.times do
        team = league.teams.create!(name: Faker::Team.unique.creature.titleize)
        (2..8).each do |position|
          add_hitters(team: team, quanity: 2, position: position)
        end

        add_hitters(team: team, quanity: 1, position: 7)
      end
    end
  end

  def add_hitter_contract(hitter, team)
    contract = hitter.build_contract(
      team: team,
      length: rand(HitterContract::LENGTH_OPTIONS)
    )
    contract.save!
  end

  private

    def hitter_attrs(position) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      attrs = {}
      attrs[:first_name] = Faker::Name.male_first_name
      attrs[:middle_name] = Faker::Name.middle_name if rand(10).zero?
      attrs[:last_name] = Faker::Name.last_name
      attrs[:primary_position] = position || rand(Hitter::POSITION_RANGE)
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
seeds.add_teams
seeds.add_hitters(quanity: 10)
