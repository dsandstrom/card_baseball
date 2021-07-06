# frozen_string_literal: true

require 'faker'

class Seeds
  def add_teams(league_quantity: 4, team_quantity: 5)
    league_quantity.times do
      league = League.create!(name: Faker::Compass.unique.direction.titleize)

      team_quantity.times do
        league.teams.create!(name: Faker::Team.unique.creature.titleize)
      end
    end
  end

  def add_hitters(team: nil, quanity: 2, position: nil)
    quanity.times do
      attrs = hitter_attrs(position)
      player = Player.new(attrs)
      player.set_roster_name
      player.save

      add_contract(player, team)
    end
  end

  def add_players_to_teams
    Team.all.each do |team|
      next if team.players.count >= 15

      (2..8).each do |position|
        add_hitters(team: team, quanity: 2, position: position)
      end

      add_hitters(team: team, quanity: 1, position: 7)
    end
  end

  def add_contract(player, team)
    contract = player.build_contract(
      team: team,
      length: rand(Contract::LENGTH_OPTIONS)
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
      attrs[:nick_name] = Faker::Name.middle_name if rand(10).zero?
      attrs[:last_name] = Faker::Name.last_name
      attrs[:bats] = Player::BATS_OPTIONS.sample
      attrs[:bunt_grade] = Player::BUNT_GRADE_OPTIONS.sample
      attrs[:speed] = rand(Player::SPEED_RANGE)
      attrs
    end

    def hitter_rating_attrs(attrs)
      attrs[:offensive_durability] = rand(Player::RATING_RANGE)
      attrs[:offensive_rating] = rand(Player::RATING_RANGE)
      attrs[:left_hitting] = rand(Player::RATING_RANGE)
      attrs[:right_hitting] = rand(Player::RATING_RANGE)
      attrs
    end

    def hitter_batting_attrs(attrs)
      attrs[:left_on_base_percentage] = rand(Player::RATING_RANGE)
      attrs[:right_on_base_percentage] = rand(Player::RATING_RANGE)
      attrs[:left_slugging] = rand(Player::RATING_RANGE)
      attrs[:right_slugging] = rand(Player::RATING_RANGE)
      attrs[:left_homerun] = rand(Player::RATING_RANGE)
      attrs[:right_homerun] = rand(Player::RATING_RANGE)
      attrs
    end

    def hitter_defense_attrs(attrs, position)
      position ||= rand(Player::POSITION_RANGE)
      attrs = hitter_primary_defense(attrs, position)
      hitter_secondary_defense(attrs, position)
    end

    def hitter_primary_defense(attrs, position)
      attrs[:primary_position] = position
      attrs[defense_key(position)] = rand(Player::DEFENSE_RANGE).abs
      case position
      when 1
        attrs[:bar1] = rand(Player::BAR_RANGE)
        attrs[:hitting_pitcher] = true
      when 2
        attrs[:bar2] = rand(Player::BAR_RANGE)
      end
      attrs
    end

    def hitter_secondary_defense(attrs, position)
      2.times do
        secondary_position = rand(2..8)
        next if secondary_position == position

        secondary_defense = defense_key(secondary_position)
        attrs[secondary_defense] = rand(Player::DEFENSE_RANGE)
        attrs
      end
      attrs
    end

    def defense_key(position)
      Player.defense_key_for_position(position)
    end
end

seeds = Seeds.new
seeds.add_teams if Team.all.none?
seeds.add_players_to_teams
seeds.add_hitters(quanity: 10)
