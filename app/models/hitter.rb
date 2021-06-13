# frozen_string_literal: true

class Hitter < ApplicationRecord
  BATS_OPTIONS = %w[R L B].freeze
  BUNT_GRADE_OPTIONS = %w[A B].freeze
  POSITION_RANGE = 1..8
  SPEED_RANGE = 0..5
  BAR_RANGE = 0..5
  RATING_RANGE = 0..99
  DEFENSE_RANGE = -20..20

  has_one :hitter_contract
  has_one :team, through: :hitter_contract

  validates :first_name, length: { maximum: 200 }
  validates :middle_name, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :roster_name, presence: true, length: { maximum: 200 },
                          uniqueness: { case_sensitive: false }
  validates :bats, presence: true, inclusion: { in: BATS_OPTIONS }
  validates :bunt_grade, presence: true, inclusion: { in: BUNT_GRADE_OPTIONS }
  validates :speed, presence: true, inclusion: { in: SPEED_RANGE }
  validates :primary_position, presence: true, inclusion: { in: POSITION_RANGE }
  validates :durability, presence: true, inclusion: { in: RATING_RANGE }
  validates :overall_rating, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_rating, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_rating, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_on_base_percentage, presence: true,
                                      inclusion: { in: RATING_RANGE }
  validates :right_on_base_percentage, presence: true,
                                       inclusion: { in: RATING_RANGE }
  validates :left_slugging, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_slugging, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_homeruns, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_homeruns, presence: true, inclusion: { in: RATING_RANGE }
  validates :pitcher_defense, inclusion: { in: DEFENSE_RANGE },
                              allow_nil: true
  validates :catcher_defense, inclusion: { in: DEFENSE_RANGE },
                              allow_nil: true
  validates :first_base_defense, inclusion: { in: DEFENSE_RANGE },
                                 allow_nil: true
  validates :second_base_defense, inclusion: { in: DEFENSE_RANGE },
                                  allow_nil: true
  validates :third_base_defense, inclusion: { in: DEFENSE_RANGE },
                                 allow_nil: true
  validates :short_stop_defense, inclusion: { in: DEFENSE_RANGE },
                                 allow_nil: true
  validates :outfield_defense, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :center_field_defense, inclusion: { in: DEFENSE_RANGE },
                                   allow_nil: true
  validates :catcher_bar, inclusion: { in: BAR_RANGE }, allow_nil: true
  validates :pitcher_bar, inclusion: { in: BAR_RANGE }, allow_nil: true

  # INSTANCE

  def name
    @name ||= build_name
  end

  def set_roster_name
    return if roster_name.present? || last_name.blank?

    range = 0
    self.roster_name = last_name
    return if first_name.blank?

    while Hitter.find_by(roster_name: roster_name)

      prefix = first_name[0..range]
      self.roster_name = "#{prefix}.#{last_name}"
      range += 1
    end
  end

  private

    def build_name
      temp = first_name.to_s
      temp += " \"#{middle_name}\" " if middle_name.present?
      "#{temp} #{last_name}".squish
    end
end
