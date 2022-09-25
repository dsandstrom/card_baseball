# frozen_string_literal: true

class Roster < ApplicationRecord
  include RankedModel

  MAX_LEVEL4 = 26

  LEVEL_MAP = {
    1 => { name: 'A' },
    2 => { name: 'AA' },
    3 => { name: 'AAA' },
    4 => { name: 'Majors' }
  }.freeze

  POSITION_MAP = {
    1 => { initials: 'SP', name: 'Starting Pitcher' },
    10 => { initials: 'RP', name: 'Relief Pitcher' },
    3 => { initials: 'IF', name: 'Infielder' },
    7 => { initials: 'OF', name: 'Outfielder' }
  }.freeze

  POSITION_MAP_LEVEL4 = {
    1 => { initials: 'SP', name: 'Starting Pitcher' },
    2 => { initials: 'C', name: 'Catcher' },
    3 => { initials: '1B', name: 'First Baseman' },
    4 => { initials: '2B', name: 'Second Baseman' },
    5 => { initials: '3B', name: 'Third Baseman' },
    6 => { initials: 'SS', name: 'Shortstop' },
    7 => { initials: 'OF', name: 'Outfielder' },
    8 => { initials: 'CF', name: 'Center Fielder' },
    9 => { initials: 'DH', name: 'Designated Hitter' },
    10 => { initials: 'RP', name: 'Relief Pitcher' }
  }.freeze

  belongs_to :team
  belongs_to :player

  validates :team_id, presence: true
  validates :player_id, presence: true, uniqueness: true
  validates :level, presence: true, inclusion: { in: LEVEL_MAP.keys }
  validates :position, presence: true

  validate :player_on_team
  validate :player_plays_position
  validate :players_at_level4

  ranks :row_order, with_same: %w[team_id level position]

  def self.level_positions(level)
    if level == 4
      [2, 3, 4, 5, 6, 7, 8, 1, 10]
    else
      [1, 10, 3, 7]
    end
  end

  def self.position_initials(position, level = 1)
    if level == 4 && ![1, 10].include?(position)
      Player.position_initials(position)
    elsif POSITION_MAP[position]
      POSITION_MAP[position][:initials]
    end
  end

  def self.position_name(position, level = 1)
    if level == 4
      POSITION_MAP_LEVEL4[position][:name]
    elsif POSITION_MAP[position]
      POSITION_MAP[position][:name]
    end
  end

  def position_initials
    @position_initials ||= Roster.position_initials(position, level)
  end

  def position_name
    @position_name ||= Roster.position_name(position, level)
  end

  private

    def player_on_team
      return unless player && team
      return if player.team == team

      errors.add(:player, 'no longer on team')
    end

    def player_plays_position
      return unless player && team && position
      return if valid_position_for_player?

      errors.add(:player, "doesn't play position")
    end

    def players_at_level4
      return unless team && level == 4
      return if persisted? && !level_changed?
      return if team.rosters.where(level: 4).count < MAX_LEVEL4

      message = 'already has the maximum amount of players at ' \
                "#{LEVEL_MAP[4][:name]} level"
      errors.add(:team, message)
    end

    # level 4, use all positions (1: SP, 10: RP)
    # level 1-3, use 4 positions (1: SP, 10: RP, 3: IF, 7: OF)
    def valid_position_for_player?
      value =
        case level
        when 4
          valid_level4_position(position)
        else
          valid_level1_position(position)
        end
      value || false
    end

    def valid_level4_position(position)
      case position
      when 1
        player.starting_pitcher?
      when 10
        player.relief_pitcher?
      when 2, 3, 4, 5, 6, 7, 8
        player.plays_position?(position)
      end
    end

    def valid_level1_position(position)
      case position
      when 1
        player.starting_pitcher?
      when 3
        player.infielder? || player.plays_position?(2)
      when 7
        player.outfielder?
      when 10
        player.relief_pitcher?
      end
    end
end
