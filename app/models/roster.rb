# frozen_string_literal: true

class Roster < ApplicationRecord
  MAX_LEVEL4 = 26

  LEVEL_MAP = {
    1 => { name: 'A' },
    2 => { name: 'AA' },
    3 => { name: 'AAA' },
    4 => { name: 'Majors' }
  }.freeze

  POSITION_MAP = {
    1 => { initials: 'SP' },
    10 => { initials: 'RP' },
    3 => { initials: 'IF' },
    7 => { initials: 'OF' }
  }.freeze

  belongs_to :team
  belongs_to :player

  validates :team_id, presence: true
  validates :player_id, presence: true
  validates :level, presence: true, inclusion: { in: LEVEL_MAP.keys }
  validates :position, presence: true

  validate :player_on_team
  validate :player_plays_position
  validate :players_at_level4

  def self.position_initials(position, level = 1)
    if level == 4 && ![1, 10].include?(position)
      Player.position_initials(position)
    elsif POSITION_MAP[position]
      POSITION_MAP[position][:initials]
    end
  end

  def position_initials
    @position_initials ||= Roster.position_initials(position, level)
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
      return unless team

      max = MAX_LEVEL4.dup
      max += 1 if persisted?
      return if team.rosters.where(level: 4).count < max

      message = 'Team already has the maximum amount of players at '\
                 "#{LEVEL_MAP[4][:name]} level"
      errors.add(:player, message)
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
        player.infielder?
      when 7
        player.outfielder?
      when 10
        player.relief_pitcher?
      end
    end
end
