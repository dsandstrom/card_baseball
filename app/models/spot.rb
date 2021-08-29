# frozen_string_literal: true

class Spot < ApplicationRecord
  validates :lineup_id, presence: true
  validates :hitter_id, presence: true, uniqueness: { scope: :lineup_id }
  # 2(c)-9(dh)
  validates :position, presence: true, inclusion: { in: 2..9 }
  validates :batting_order, presence: true, inclusion: { in: 1..9 },
                            uniqueness: { scope: :lineup_id }

  validate :position_available
  validate :correct_batters_amount
  validate :hitter_on_team
  validate :hitter_on_level

  belongs_to :lineup
  belongs_to :hitter, class_name: 'Player'

  # hitter's def score
  def defense
    @defense ||= build_defense if hitter && position
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

    def hitter_on_team
      return unless hitter && lineup&.team
      return if hitter.team == lineup.team

      errors.add(:hitter, 'no longer on team')
    end

    def hitter_on_level
      return unless hitter && lineup&.team
      return unless hitter.team == lineup.team
      return if hitter.roster&.level == 4

      errors.add(:hitter, "not on #{Roster::LEVEL_MAP[4][:name]} roster")
    end

    def build_defense
      value = hitter.position_defense(position)
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
end
