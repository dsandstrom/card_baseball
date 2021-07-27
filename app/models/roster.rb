# frozen_string_literal: true

# TODO: validate max 26 at level 4

class Roster < ApplicationRecord
  LEVEL_MAP = {
    1 => { name: 'A' },
    2 => { name: 'AA' },
    3 => { name: 'AAA' },
    4 => { name: 'Majors' }
  }.freeze

  POSITION_MAP = {
    1 => { name: 'SP' },
    3 => { name: 'IF' },
    7 => { name: 'OF' },
    10 => { name: 'RP' }
  }.freeze

  belongs_to :team
  belongs_to :player

  validates :team_id, presence: true
  validates :player_id, presence: true
  validates :level, presence: true, inclusion: { in: LEVEL_MAP.keys }
  validates :position, presence: true, inclusion: { in: POSITION_MAP.keys }

  validate :player_on_team
  validate :player_plays_position

  private

    def player_on_team
      return unless player && team
      return if player.team == team

      errors.add(:player, 'no longer on team')
    end

    def player_plays_position
      return unless player && team
      return if valid_position_for_player?

      errors.add(:player, "doesn't play position")
    end

    def valid_position_for_player?
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
