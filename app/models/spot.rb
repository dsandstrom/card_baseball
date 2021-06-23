# frozen_string_literal: true

class Spot < ApplicationRecord
  validates :lineup_id, presence: true
  validates :hitter_id, presence: true, uniqueness: { scope: :lineup_id }
  # 2(c)-9(dh)
  validates :position, presence: true, inclusion: { in: 2..9 }
  validates :batting_order, presence: true, inclusion: { in: 1..9 },
                            uniqueness: { scope: :lineup_id }

  validate :position_available
  validate :hitter_plays_position
  validate :correct_batters_amount

  belongs_to :lineup
  belongs_to :hitter

  # hitter's def score
  def defense
    @defense ||= hitter.defense_for_position(position) if hitter && position
  end

  def position_initials
    @position_initials ||= Hitter::POSITION_OPTIONS[position][:initials]
  end

  private

    def position_available
      return if position.blank? || lineup.blank?

      count = lineup.spots_at_position(position, id).count
      return if count.zero? || (count == 1 && position == 7)

      errors.add(:position, 'already taken in lineup')
    end

    def hitter_plays_position
      return if position.blank? || hitter.blank? || position == 9
      return if hitter.defense_for_position(position).present?

      errors.add(:hitter, "can't play position")
    end

    def correct_batters_amount
      return unless batting_order == 9 && lineup && !lineup&.with_dh?

      errors.add(:batting_order, 'not allowed to be 9 with this lineup')
    end
end
