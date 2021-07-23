# frozen_string_literal: true

require 'faker'

class Seeds
  def add_teams(league_quantity: 4, team_quantity: 5)
    league_quantity.times do
      league = League.create!(name: Faker::Compass.unique.direction.titleize)

      team_quantity.times do
        name = Faker::Team.unique.creature.titleize
        identifier = Faker::Team.unique.mascot.gsub(/[\s.,]/, '')[0..2].upcase
        league.teams.create!(name: name, identifier: identifier)
      end
    end
  end

  def add_hitters(team: nil, quanity: 2, position: nil)
    quanity.times do
      attrs = hitter_attrs(position)
      player = Player.new(attrs)
      player.set_roster_name
      player.save!

      add_contract(player, team)
    end
  end

  def add_pitchers(team: nil, quanity: 2, type: nil)
    quanity.times do
      attrs = pitcher_attrs(type)
      player = Player.new(attrs)
      player.set_roster_name
      player.save!

      add_contract(player, team)
    end
  end

  def add_hitters_to_teams
    Team.all.each do |team|
      next if team.hitters.count >= 15

      (2..8).each do |position|
        add_hitters(team: team, quanity: 2, position: position)
      end

      add_hitters(team: team, quanity: 1, position: 7)
    end
  end

  def add_pitchers_to_teams
    Team.all.each do |team|
      next if team.pitchers.count >= 10

      add_pitchers(team: team, quanity: 5, type: 'S')
      add_pitchers(team: team, quanity: 6, type: 'R')
    end
  end

  def add_contract(player, team)
    contract = player.build_contract(
      team: team,
      length: rand(Contract::LENGTH_OPTIONS)
    )
    contract.save!
  end

  def add_users(quanity = 1)
    quanity.times do
      name = Faker::Name.unique.name
      User.create!(name: name,
                   email: Faker::Internet.unique.safe_email(name: name),
                   password: 'password', password_confirmation: 'password')
    end
  end

  def add_admin
    User.create!(name: 'Bob Admin',
                 email: 'admin@example.net', admin_role: true,
                 password: 'password', password_confirmation: 'password')
  end

  private

    def hitter_attrs(position)
      attrs = {}
      attrs = player_attrs(attrs)
      attrs = hitter_rating_attrs(attrs)
      attrs = hitter_batting_attrs(attrs)
      hitter_defense_attrs(attrs, position)
    end

    def pitcher_attrs(type)
      attrs = {}
      attrs = player_attrs(attrs)
      attrs = hitter_rating_attrs(attrs)
      attrs = hitter_batting_attrs(attrs)
      attrs = pitcher_rating_attrs(attrs, type)
      pitcher_defense_attrs(attrs)
    end

    def player_attrs(attrs)
      attrs[:first_name] = Faker::Name.male_first_name
      attrs[:nick_name] = Faker::Name.middle_name if rand(10).zero?
      attrs[:last_name] = Faker::Name.last_name
      attrs[:bats] = Player::BATS_MAP.keys.sample
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

    def pitcher_rating_attrs(attrs, type = nil)
      attrs[:throws] = Player::THROWS_MAP.keys.sample
      attrs[:pitcher_rating] = rand(Player::RATING_RANGE)
      attrs[:pitching_durability] = rand(Player::RATING_RANGE)
      pitcher_type_rating_attrs(attrs, type)
    end

    def pitcher_type_rating_attrs(attrs, type = nil)
      type ||= Player::PITCHER_TYPES.keys.sample

      attrs[:pitcher_type] = type
      attrs[pitching_key(type)] = rand(Player::RATING_RANGE)
      if type == 'S' && rand(4).zero?
        attrs[pitching_key('R')] = rand(Player::RATING_RANGE)
      end
      attrs
    end

    def hitter_defense_attrs(attrs, position)
      position ||= rand(Player::POSITION_RANGE)
      attrs = hitter_primary_defense(attrs, position)
      player_secondary_defense(attrs, position)
    end

    def pitcher_defense_attrs(attrs)
      attrs = pitcher_primary_defense(attrs)
      return attrs unless rand(10).zero?

      player_secondary_defense(attrs, 1)
    end

    def hitter_primary_defense(attrs, position)
      attrs[:primary_position] = position
      attrs[defense_key(position)] = rand(Player::DEFENSE_RANGE).abs
      hitter_bar(attrs, position)
    end

    def hitter_bar(attrs, position)
      case position
      when 1
        attrs[:bar1] = rand(Player::BAR_RANGE)
        attrs[:hitting_pitcher] = true
        attrs = pitcher_rating_attrs(attrs)
      when 2
        attrs[:bar2] = rand(Player::BAR_RANGE)
      end
      attrs
    end

    def pitcher_primary_defense(attrs)
      attrs[:primary_position] = 1
      attrs[defense_key(1)] = rand(Player::DEFENSE_RANGE).abs
      attrs[:bar1] = rand(Player::BAR_RANGE)
      attrs
    end

    def player_secondary_defense(attrs, position)
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

    def pitching_key(type)
      "#{Player::PITCHER_TYPES[type][:key]}_pitching".to_sym
    end
end

seeds = Seeds.new
seeds.add_teams if Team.all.none?
seeds.add_hitters(quanity: 10) if Player.hitters.none?
seeds.add_hitters_to_teams
seeds.add_pitchers(quanity: 10) if Player.pitchers.none?
seeds.add_pitchers_to_teams

seeds.add_users(5) if User.none?
seeds.add_admin if User.admins.none?
