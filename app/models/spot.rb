# frozen_string_literal: true

class Spot < ApplicationRecord
  validates :lineup_id, presence: true
  validates :player_id, uniqueness: { scope: :lineup_id }
  validates :player, presence: true, if: :player_id_present?
  # 2(c)-9(dh)
  validates :position, presence: true, inclusion: { in: 1..9 }
  validates :batting_order, presence: true, inclusion: { in: 1..9 },
                            uniqueness: { scope: :lineup_id }

  validate :position_available
  validate :player_unless_pitcher
  validate :player_on_team
  validate :player_on_level
  validate :player_plays_position

  belongs_to :lineup
  belongs_to :player, optional: true

  # player's def score
  def defense
    @defense ||= build_defense if player && position
  end

  def position_initials
    @position_initials ||= Player.position_initials(position)
  end

  private

    def position_available
      return if position.blank? || lineup.blank?

      count = lineup.spots_at_position(position, id).count
      return if count.zero? || (count == 1 && position == 7)

      errors.add(:position, 'already taken in lineup')
    end

    def correct_batters_amount
      return unless batting_order == 9 && lineup && !lineup&.with_dh?

      errors.add(:batting_order, 'not allowed to be 9 with this lineup')
    end

    def player_unless_pitcher
      return unless position
      return if player || position == 1

      errors.add(:player, 'required')
    end

    def player_on_team
      return unless player && lineup&.team
      return if player.team == lineup.team

      errors.add(:player, 'no longer on team')
    end

    def player_on_level
      return unless player && lineup&.team
      return unless player.team == lineup.team
      return if player.roster&.level == 4

      errors.add(:player, "not on #{Roster::LEVEL_MAP[4][:name]} roster")
    end

    def player_plays_position
      return if position.blank? || player.blank? || position == 9
      return if position != 1
      return if player.starting_pitcher? || player.relief_pitcher?

      errors.add(:position, "can't be filled by player")
    end

    def build_defense
      value = player.position_defense(position)
      return value if value.present?

      case position
      when 2
        -25
      when 4, 6
        -20
      else
        -10
      end
    end

    def player_id_present?
      player_id.present?
    end
end
