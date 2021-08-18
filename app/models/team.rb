# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :identifier, presence: true, uniqueness: { case_sensitive: false }
  validates :league_id, presence: true

  belongs_to :league
  belongs_to :user, optional: true
  has_many :contracts, dependent: :nullify
  has_many :players, through: :contracts
  has_many :lineups, dependent: :destroy
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

  private

    def auto_roster_level4_starting_pitchers
      level = 4

      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      position_balance = 5 - players_at_level_and_position(level, 1).count

      position_balance.times do
        break if level_balance <= 0

        best = rosterless.starting_pitchers.order(pitcher_rating: :desc).first
        next unless best

        rosters.create!(player: best, level: level, position: 1)
        level_balance -= 1
      end
    end

    def auto_roster_level4_relief_pitchers
      level = 4

      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      position_balance = 6 - players_at_level_and_position(level, 10).count

      position_balance.times do
        break if level_balance <= 0

        best = rosterless.relief_pitchers.order(pitcher_rating: :desc).first
        next unless best

        rosters.create!(player: best, level: level, position: 10)
        level_balance -= 1
      end
    end

    def auto_roster_level4_hitters
      level = 4

      level_count = players_at_level(level).count
      level_balance = Roster::MAX_LEVEL4 - level_count
      return if level_balance <= 0

      (1..4).each do |index|
        break if level_balance <= 0

        [2, 3, 4, 5, 6, 7, 8].each do |position|
          break if level_balance <= 0
          next if players_at_level_and_position(level, position).count >= index

          options = rosterless.where(primary_position: position)
          if options.none?
            options = rosterless.where("defense#{position} IS NOT NULL")
          end
          next if options.none?

          best = options.order(offensive_rating: :desc,
                               "defense#{position}": :desc).first
          rosters.create!(player: best, level: level, position: position)
          level_balance -= 1
        end
      end
    end

    def auto_roster_lower_levels
      disperse_starting_pitchers
      disperse_relief_pitchers
      disperse_infielders
      disperse_outfielders
    end

    def disperse_starting_pitchers
      starting_pitchers = rosterless.starting_pitchers
      return if starting_pitchers.none?

      per_level = starting_pitchers.count / 3
      extra_levels = starting_pitchers.count % 3

      [3, 2, 1].each do |level|
        amount = per_level
        amount += 1 if extra_levels.positive?

        amount.times do
          best = rosterless.starting_pitchers.order(pitcher_rating: :desc).first
          rosters.create!(player: best, level: level, position: 1)
        end

        extra_levels -= 1
      end
    end

    def disperse_relief_pitchers
      position = 10

      relief_pitchers = rosterless.relief_pitchers
      return if relief_pitchers.none?

      per_level = relief_pitchers.count / 3
      extra_levels = relief_pitchers.count % 3

      while rosterless.relief_pitchers.any?
        index = 1
        [3, 2, 1].each do |level|
          next if players_at_level_and_position(level, position).count >= index

          amount = per_level
          amount += 1 if extra_levels.positive?

          amount.times do
            best = rosterless.relief_pitchers.order(pitcher_rating: :desc).first
            break unless best

            rosters.create!(player: best, level: level, position: position)
          end
          extra_levels -= 1
        end
        index += 1
      end
    end

    def disperse_infielders
      position = 3
      infielders = rosterless.where(primary_position: 2..6)

      per_level = infielders.count / 3
      extra_levels = infielders.count % 3

      while rosterless.where(primary_position: 2..6).any?
        index = 1
        [3, 2, 1].each do |level|
          next if players_at_level_and_position(level, position).count >= index

          amount = per_level
          amount += 1 if extra_levels.positive?

          amount.times do
            best = rosterless.where(primary_position: 2..6).order(offensive_rating: :desc).first
            break unless best

            rosters.create!(player: best, level: level, position: position)
          end
          extra_levels -= 1
        end
        index += 1
      end
    end

    def disperse_outfielders
      position = 7
      outfielders = rosterless.where(primary_position: [7, 8])

      per_level = outfielders.count / 3
      extra_levels = outfielders.count % 3

      while rosterless.where(primary_position: [7, 8]).any?
        index = 1
        [3, 2, 1].each do |level|
          next if players_at_level_and_position(level, position).count >= index

          amount = per_level
          amount += 1 if extra_levels.positive?

          amount.times do
            best = rosterless.where(primary_position: [7,
                                                       8]).order(offensive_rating: :desc).first
            break unless best

            rosters.create!(player: best, level: level, position: position)
          end
          extra_levels -= 1
        end
        index += 1
      end
    end
end
