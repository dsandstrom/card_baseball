# frozen_string_literal: true

class Hitter < ApplicationRecord
  BATS_OPTIONS = %w[R L B].freeze
  BUNT_GRADE_OPTIONS = %w[A B].freeze
  POSITION_RANGE = 1..8
  SPEED_RANGE = 0..5
  BAR_RANGE = 0..5
  RATING_RANGE = 0..99
  DEFENSE_RANGE = -20..20
  POSITION_OPTIONS = {
    1 => { initial: 'P', name: 'Pitcher' },
    2 => { initial: 'C', name: 'Catcher' },
    3 => { initial: '1B', name: 'First Base' },
    4 => { initial: '2B', name: 'Second Base' },
    5 => { initial: '3B', name: 'Third Base' },
    6 => { initial: 'SS', name: 'Shortstop' },
    7 => { initial: 'OF', name: 'Outfield' },
    8 => { initial: 'CF', name: 'Center Field' }
  }.freeze

  has_one :contract, class_name: 'HitterContract', dependent: :destroy
  has_one :team, through: :contract

  validates :first_name, length: { maximum: 200 }
  validates :middle_name, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :roster_name, presence: true, length: { maximum: 200 },
                          uniqueness: { case_sensitive: false }
  validates :bats, presence: true, inclusion: { in: BATS_OPTIONS }
  validates :bunt_grade, presence: true, inclusion: { in: BUNT_GRADE_OPTIONS }
  validates :speed, presence: true, inclusion: { in: SPEED_RANGE }
  validates :primary_position, presence: true,
                               inclusion: { in: POSITION_OPTIONS.keys }
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
  validates :shortstop_defense, inclusion: { in: DEFENSE_RANGE },
                                allow_nil: true
  validates :outfield_defense, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :center_field_defense, inclusion: { in: DEFENSE_RANGE },
                                   allow_nil: true
  validates :catcher_bar, inclusion: { in: BAR_RANGE }, allow_nil: true
  validates :pitcher_bar, inclusion: { in: BAR_RANGE }, allow_nil: true

  # CLASS

  def self.position_form_options
    POSITION_OPTIONS.map do |key, value|
      [value[:name], key]
    end
  end

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

  def primary_position_initial
    @primary_position_initial ||= build_primary_position_initial
  end

  private

    def build_name
      temp = first_name.to_s
      temp += " \"#{middle_name}\" " if middle_name.present?
      "#{temp} #{last_name}".squish
    end

    def build_primary_position_initial
      return if primary_position.blank?

      if primary_position == 1 && hitting_pitcher?
        'P+H'
      else
        POSITION_OPTIONS[primary_position][:initial]
      end
    end
end
