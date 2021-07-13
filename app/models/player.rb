# frozen_string_literal: true

class Player < ApplicationRecord
  BATS_OPTIONS = %w[R L B].freeze
  BUNT_GRADE_OPTIONS = %w[A B].freeze
  POSITION_RANGE = 1..8
  SPEED_RANGE = 0..5
  BAR_RANGE = 0..5
  RATING_RANGE = 0..99
  DEFENSE_RANGE = -20..20
  POSITION_MAP = {
    1 => { initials: 'P', name: 'Pitcher', key: :pitcher },
    2 => { initials: 'C', name: 'Catcher', key: :catcher },
    3 => { initials: '1B', name: 'First Base', key: :first_base },
    4 => { initials: '2B', name: 'Second Base', key: :second_base },
    5 => { initials: '3B', name: 'Third Base', key: :third_base },
    6 => { initials: 'SS', name: 'Shortstop', key: :shortstop },
    7 => { initials: 'OF', name: 'Outfield', key: :outfield },
    8 => { initials: 'CF', name: 'Center Field', key: :center_field },
    9 => { initials: 'DH', name: 'Designated Hitter', key: :dh }
  }.freeze

  validates :first_name, length: { maximum: 200 }
  validates :nick_name, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :roster_name, presence: true, length: { maximum: 200 },
                          uniqueness: { case_sensitive: false }
  validates :bats, presence: true, inclusion: { in: BATS_OPTIONS }
  validates :bunt_grade, presence: true, inclusion: { in: BUNT_GRADE_OPTIONS }
  validates :speed, presence: true, inclusion: { in: SPEED_RANGE }
  validates :primary_position, presence: true, inclusion: { in: POSITION_RANGE }
  validates :offensive_durability, inclusion: { in: RATING_RANGE },
                                   allow_nil: true
  validates :offensive_rating, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_hitting, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_hitting, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_on_base_percentage, presence: true,
                                      inclusion: { in: RATING_RANGE }
  validates :right_on_base_percentage, presence: true,
                                       inclusion: { in: RATING_RANGE }
  validates :left_slugging, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_slugging, presence: true, inclusion: { in: RATING_RANGE }
  validates :left_homerun, presence: true, inclusion: { in: RATING_RANGE }
  validates :right_homerun, presence: true, inclusion: { in: RATING_RANGE }
  validates :defense1, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense2, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense3, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense4, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense5, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense6, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense7, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :defense8, inclusion: { in: DEFENSE_RANGE }, allow_nil: true
  validates :bar1, inclusion: { in: BAR_RANGE }, allow_nil: true
  validates :bar2, inclusion: { in: BAR_RANGE }, allow_nil: true

  has_one :contract
  has_one :team, through: :contract
  # has_many :spots, dependent: :destroy
  # has_many :lineups, through: :spots

  # CLASS

  def self.position_form_options
    POSITION_RANGE.map do |position|
      [POSITION_MAP[position][:name], position]
    end
  end

  def self.position_initials(position)
    return unless position
    return unless POSITION_MAP[position]

    POSITION_MAP[position][:initials]
  end

  def self.position_name(position)
    return unless position
    return unless POSITION_MAP[position]

    POSITION_MAP[position][:name]
  end

  def self.defense_key_for_position(position)
    return unless position && POSITION_RANGE.include?(position)

    "defense#{position}".to_sym
  end

  def self.bar_key_for_position(position)
    return unless position && [1, 2].include?(position)

    "bar#{position}".to_sym
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

    while Player.find_by(roster_name: roster_name)

      prefix = first_name[0..range]
      self.roster_name = "#{prefix}.#{last_name}"
      range += 1
    end
  end

  def primary_position_initials
    @primary_position_initials ||= build_primary_position_initials
  end

  def position_defense(position)
    return 0 if position == 9

    key = Player.defense_key_for_position(position)
    return unless key

    send(key)
  end

  def bar_for_position(position)
    key = Player.bar_key_for_position(position)
    return unless key

    send(key)
  end

  def positions
    @positions ||= build_positions
  end

  private

    def build_name
      temp = first_name.to_s
      temp += " \"#{nick_name}\" " if nick_name.present?
      "#{temp} #{last_name}".squish
    end

    def build_primary_position_initials
      return if primary_position.blank?

      if primary_position == 1 && hitting_pitcher?
        'P+H'
      else
        POSITION_MAP[primary_position][:initials]
      end
    end

    def build_positions
      temp = []
      POSITION_RANGE.each do |position|
        temp << position if position_defense(position).present?
      end
      temp
    end
end