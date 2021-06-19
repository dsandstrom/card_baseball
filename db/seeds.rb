# frozen_string_literal: true

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

    def hitter_attrs(position)
      attrs = {}
      attrs = hitter_basic_attrs(attrs)
      attrs = hitter_rating_attrs(attrs)
      attrs = hitter_batting_attrs(attrs)
      hitter_defense_attrs(attrs, position)
    end

    def hitter_basic_attrs(attrs)
      attrs[:first_name] = Faker::Name.male_first_name
      attrs[:middle_name] = Faker::Name.middle_name if rand(10).zero?
      attrs[:last_name] = Faker::Name.last_name
      attrs[:bats] = Hitter::BATS_OPTIONS.sample
      attrs[:bunt_grade] = Hitter::BUNT_GRADE_OPTIONS.sample
      attrs[:speed] = rand(Hitter::SPEED_RANGE)
      attrs
    end

    def hitter_rating_attrs(attrs)
      attrs[:durability] = rand(Hitter::RATING_RANGE)
      attrs[:overall_rating] = rand(Hitter::RATING_RANGE)
      attrs[:left_rating] = rand(Hitter::RATING_RANGE)
      attrs[:right_rating] = rand(Hitter::RATING_RANGE)
      attrs
    end

    def hitter_batting_attrs(attrs)
      attrs[:left_on_base_percentage] = rand(Hitter::RATING_RANGE)
      attrs[:right_on_base_percentage] = rand(Hitter::RATING_RANGE)
      attrs[:left_slugging] = rand(Hitter::RATING_RANGE)
      attrs[:right_slugging] = rand(Hitter::RATING_RANGE)
      attrs[:left_homeruns] = rand(Hitter::RATING_RANGE)
      attrs[:right_homeruns] = rand(Hitter::RATING_RANGE)
      attrs
    end

    def hitter_defense_attrs(attrs, position)
      position ||= rand(Hitter::POSITION_RANGE)
      attrs = hitter_primary_defense(attrs, position)
      hitter_secondary_defense(attrs, position)
    end

    def hitter_primary_defense(attrs, position)
      attrs[:primary_position] = position
      attrs[defense_key(position)] = rand(Hitter::DEFENSE_RANGE).abs
      case position
      when 1
        attrs[:pitcher_bar] = rand(Hitter::BAR_RANGE)
        attrs[:hitting_pitcher] = true
      when 2
        attrs[:catcher_bar] = rand(Hitter::BAR_RANGE)
      end
      attrs
    end

    def hitter_secondary_defense(attrs, position)
      2.times do
        secondary_position = rand(2..8)
        next if secondary_position == position

        secondary_defense = defense_key(secondary_position)
        attrs[secondary_defense] = rand(Hitter::DEFENSE_RANGE)
        attrs
      end
      attrs
    end

    def defense_key(position)
      "#{Hitter::POSITION_OPTIONS[position][:key]}_defense".to_sym
    end
end

seeds = Seeds.new
seeds.add_teams
seeds.add_hitters(quanity: 10)
