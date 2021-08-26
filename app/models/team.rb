# frozen_string_literal: true

class Team < ApplicationRecord # rubocop:disable Metrics/ClassLength
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  validates :league_id, presence: true

  belongs_to :league
  belongs_to :user, optional: true
  has_many :contracts, dependent: :nullify
  has_many :players, through: :contracts
  has_many :lineups, dependent: :destroy
  has_many :spots, through: :lineups
  has_many :rosters, dependent: :destroy

  # CLASS

  # INSTANCE

  def hitters
    players.hitters.order(offensive_rating: :desc)
  end

  def pitchers
    players.pitchers.order(pitcher_rating: :desc)
  end

  def rosterless
    @rosterless ||=
      players.left_outer_joins(:roster).where('rosters.id IS NULL')
  end

  def players_at_level(level)
    players.joins(:roster).where('rosters.level = ?', level)
  end

  def players_at_level_and_position(level, position)
    players.joins(:roster)
           .where('rosters.level = ? AND rosters.position = ?', level, position)
  end

  def auto_roster!
    auto_roster_level4_starting_pitchers
    auto_roster_level4_relief_pitchers
    auto_roster_level4_hitters
    auto_roster_lower_levels
  end

  def cleanup_lineup_spots
    spots.joins(hitter: :roster).where('rosters.level != ?', 4).destroy_all
  end

  private

    def rosterless_starting_pitchers
      rosterless.starting_pitchers
    end

    def best_rosterless_starting_pitcher
      rosterless_starting_pitchers.order(pitcher_rating: :desc).first
    end

    def rosterless_relief_pitchers
      rosterless.relief_pitchers
    end

    def best_rosterless_relief_pitcher
      rosterless.relief_pitchers.order(pitcher_rating: :desc).first
    end

    def rosterless_infielders
      rosterless.where(primary_position: 2..6)
    end

    def best_rosterless_infielder
      rosterless_infielders.order(offensive_rating: :desc).first
    end

    def rosterless_outfielders
      rosterless.where(primary_position: [7, 8])
    end

    def best_rosterless_outfielder
      rosterless_outfielders.order(offensive_rating: :desc).first
    end

    def rosterless_at_position(position)
      options = rosterless.where(primary_position: position)
      return options if options.any?

      rosterless.where("defense#{position} IS NOT NULL")
    end

    def best_rosterless_at_position(position)
      options = rosterless_at_position(position)
      options.order(offensive_rating: :desc, "defense#{position}": :desc).first
    end

    def create_roster(roster_attrs)
      return unless roster_attrs[:player]

      rosters.create!(roster_attrs)
    end

    def create_starting_pitcher_rosters(amount, level)
      amount.times do
        create_roster player: best_rosterless_starting_pitcher, level: level,
                      position: 1
      end
    end

    def create_relief_pitcher_rosters(amount, level)
      amount.times do
        create_roster player: best_rosterless_relief_pitcher, level: level,
                      position: 10
      end
    end

    def create_outfielder_rosters(amount, level)
      amount.times do
        create_roster(player: best_rosterless_outfielder, level: level,
                      position: 7)
      end
    end

    def create_infielder_rosters(amount, level)
      amount.times do
        create_roster(player: best_rosterless_infielder, level: level,
                      position: 3)
      end
    end

    def auto_roster_lower_levels
      create_lower_level_starting_pitcher_rosters
      create_lower_level_relief_pitcher_rosters
      create_lower_level_infielder_rosters
      create_lower_level_outfielder_rosters
    end

    def auto_roster_level4_starting_pitchers
      level = 4

      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      position_balance = 5 - players_at_level_and_position(level, 1).count
      position_balance = level_balance if level_balance < position_balance
      create_starting_pitcher_rosters(position_balance, level)
    end

    def auto_roster_level4_relief_pitchers
      level = 4

      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      position_balance = 6 - players_at_level_and_position(level, 10).count
      position_balance = level_balance if level_balance < position_balance
      create_relief_pitcher_rosters(position_balance, level)
    end

    def disperse_level4_positions(level_balance, amount)
      [2, 3, 4, 5, 6, 7, 8].each do |position|
        break if level_balance <= 0
        next if players_at_level_and_position(4, position).count >= amount

        best = best_rosterless_at_position(position)
        next unless best

        create_roster(player: best, level: 4, position: position)
        level_balance -= 1
      end

      level_balance
    end

    def auto_roster_level4_hitters
      level = 4
      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      # trying to spread players out
      # check to see if any at 0, then 1 ...
      (1..4).each do |amount_at_position|
        break if level_balance <= 0

        level_balance = disperse_level4_positions(level_balance,
                                                  amount_at_position)
      end
    end

    def create_lower_level_starting_pitcher_rosters
      starting_pitchers_count = rosterless_starting_pitchers.count
      return if starting_pitchers_count <= 0

      per_level = starting_pitchers_count / 3
      extra_levels = starting_pitchers_count % 3

      [3, 2, 1].each do |level|
        amount = per_level
        amount += 1 if extra_levels.positive?
        create_starting_pitcher_rosters(amount, level)
        extra_levels -= 1
      end
    end

    def disperse_relief_pitchers(per_level, extra_levels)
      position = 10
      index = 1
      [3, 2, 1].each do |level|
        next if players_at_level_and_position(level, position).count >= index

        amount = per_level
        amount += 1 if extra_levels.positive?
        create_relief_pitcher_rosters(amount, level)
        extra_levels -= 1
      end
      index += 1
    end

    def create_lower_level_relief_pitcher_rosters
      relief_pitchers_count = rosterless_relief_pitchers.count
      return if relief_pitchers_count <= 0

      per_level = relief_pitchers_count / 3
      extra_levels = relief_pitchers_count % 3

      while rosterless.relief_pitchers.any?
        disperse_relief_pitchers(per_level, extra_levels)
      end
    end

    def disperse_infielders(per_level, extra_levels)
      position = 3
      index = 1
      [3, 2, 1].each do |level|
        next if players_at_level_and_position(level, position).count >= index

        amount = per_level
        amount += 1 if extra_levels.positive?
        create_infielder_rosters(amount, level)
        extra_levels -= 1
      end
      index += 1
    end

    def create_lower_level_infielder_rosters
      infielders = rosterless_infielders
      per_level = infielders.count / 3
      extra_levels = infielders.count % 3

      while rosterless_infielders.any?
        disperse_infielders(per_level, extra_levels)
      end
    end

    def disperse_outfielders(per_level, extra_levels)
      position = 7
      index = 1
      [3, 2, 1].each do |level|
        next if players_at_level_and_position(level, position).count >= index

        amount = per_level
        amount += 1 if extra_levels.positive?
        create_outfielder_rosters(amount, level)
        extra_levels -= 1
      end
      index += 1
    end

    def create_lower_level_outfielder_rosters
      outfielders_count = rosterless_outfielders.count
      per_level = outfielders_count / 3
      extra_levels = outfielders_count % 3

      while rosterless_outfielders.any?
        disperse_outfielders(per_level, extra_levels)
      end
    end
end
