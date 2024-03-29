# frozen_string_literal: true

# TODO: validate throws presence when pitcher
# TODO: add roster level filter

class Player < ApplicationRecord # rubocop:disable Metrics/ClassLength
  BUNT_GRADE_OPTIONS = %w[A B].freeze
  POSITION_RANGE = 1..8
  SPEED_RANGE = 0..6
  BAR_RANGE = -5..5
  RATING_RANGE = 0..130
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
  THROWS_MAP = {
    'L' => { name: 'Left' },
    'R' => { name: 'Right' }
  }.freeze
  BATS_MAP = {
    'L' => { name: 'Left' },
    'R' => { name: 'Right' },
    'B' => { name: 'Switch' }
  }.freeze
  PITCHER_TYPES = {
    'R' => { name: 'Reliever', key: :relief },
    'S' => { name: 'Starter', key: :starting }
  }.freeze
  DEFAULT_THROW = 'R'

  validates :first_name, length: { maximum: 200 }
  validates :nick_name, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :roster_name, presence: true, length: { maximum: 200 },
                          uniqueness: { case_sensitive: false }
  validates :bats, presence: true, inclusion: { in: BATS_MAP.keys }
  validates :throws, inclusion: { in: THROWS_MAP.keys }, allow_nil: true
  validates :bunt_grade, presence: true, inclusion: { in: BUNT_GRADE_OPTIONS }
  validates :speed, presence: true, inclusion: { in: SPEED_RANGE }
  validates :primary_position, presence: true, inclusion: { in: POSITION_RANGE }
  validates :offensive_durability, inclusion: { in: RATING_RANGE },
                                   allow_nil: true
  validates :pitching_durability, inclusion: { in: RATING_RANGE },
                                  allow_nil: true
  validates :offensive_rating, presence: true, inclusion: { in: RATING_RANGE }
  validates :pitcher_rating, inclusion: { in: RATING_RANGE }, allow_nil: true
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
  validates :pitcher_type, inclusion: { in: PITCHER_TYPES.keys },
                           allow_nil: true
  validates :starting_pitching, inclusion: { in: RATING_RANGE }, allow_nil: true
  validates :relief_pitching, inclusion: { in: RATING_RANGE }, allow_nil: true

  has_one :contract
  has_one :team, through: :contract
  has_many :spots, dependent: :destroy
  has_many :lineups, through: :spots
  has_one :roster

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

  def self.hitters
    query = (2..8).map do |position|
      "players.defense#{position} IS NOT NULL"
    end.join(' OR ')
    Player.where(query)
  end

  def self.pitchers
    query = 'players.pitcher_rating IS NOT NULL ' \
            'AND players.defense1 IS NOT NULL'
    Player.where(query)
  end

  def self.starting_pitchers
    pitchers.where(pitcher_type: 'S')
  end

  def self.relief_pitchers
    pitchers.where(pitcher_type: 'R')
  end

  def self.filter_by(filters = {})
    players = all
    players = players.filter_by_name(filters[:query])
    players = players.filter_by_free_agency(filters[:free_agent])
    players = players.filter_by_positions(filters)
    players = players.filter_hitters(filters)
    players = players.filter_pitchers(filters)
    players.order(build_order_param(filters[:order]))
  end

  def self.filter_hitters(filters)
    players = all.filter_by_bats(filters[:bats])
    players = players.filter_by_bunt_grade(filters[:bunt_grade])
    players.filter_by_speed(filters[:speed])
  end

  def self.filter_pitchers(filters)
    players = all.filter_by_pitcher_type(filters[:pitcher_type])
    players.filter_by_throws(filters[:throws])
  end

  def self.filter_by_name(name)
    return all if name.blank?

    query = %w[first_name nick_name last_name].map do |c|
      "players.#{c} ILIKE :name"
    end.join(' OR ')
    where(query, name: "%#{name}%")
  end

  def self.filter_by_free_agency(free_agent)
    return all unless free_agent == 'true'

    query = 'contracts.team_id IS NULL'
    left_outer_joins(:contract).where(query)
  end

  def self.filter_by_positions(filters)
    query_parts = []
    POSITION_RANGE.each do |position|
      key = "position#{position}".to_sym
      next unless filters[key] == 'true'

      query_parts << "players.defense#{position} IS NOT NULL"
    end
    return all if query_parts.none?

    where(query_parts.join(' OR '))
  end

  def self.filter_by_bats(bats)
    return all if bats.blank?
    return all unless BATS_MAP.keys.include?(bats)

    where('players.bats = ?', bats)
  end

  def self.filter_by_bunt_grade(bunt_grade)
    return all if bunt_grade.blank?
    return all unless bunt_grade == 'A'

    where('players.bunt_grade = ?', bunt_grade)
  end

  def self.filter_by_speed(speed)
    return all if speed.blank?

    speed = speed.to_i
    return all unless [1, 2, 3, 4, 5, 6].include?(speed)

    where('players.speed > ?', speed)
  end

  def self.filter_by_pitcher_type(pitcher_type)
    return all if pitcher_type.blank?
    return all unless PITCHER_TYPES.keys.include?(pitcher_type)

    where('players.pitcher_type = ?', pitcher_type)
  end

  def self.filter_by_throws(throws)
    return all if throws.blank?
    return all unless THROWS_MAP.keys.include?(throws)

    where('players.throws = ?', throws)
  end

  # used by .filter_by
  # TODO: when defense, sort by selected positions
  def self.build_order_param(column)
    case column
    when 'offense'
      'players.offensive_rating desc'
    when 'pitching'
      'players.pitcher_rating desc'
    else
      'players.last_name asc, players.first_name asc'
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

    while Player.find_by(roster_name:)

      prefix = first_name[0..range]
      self.roster_name = "#{prefix}.#{last_name}"
      range += 1
    end
  end

  def primary_position_initials
    @primary_position_initials ||= build_primary_position_initials
  end

  # QUESTION: when dh, return nil unless hitter?
  def position_defense(position)
    return 0 if position == 9

    key = Player.defense_key_for_position(position)
    return unless key

    send(key)
  end

  def position_bar(position)
    key = Player.bar_key_for_position(position)
    return unless key

    send(key)
  end

  def positions
    @positions ||= build_positions
  end

  def verbose_pitcher_type
    @verbose_pitcher_type ||=
      if PITCHER_TYPES[pitcher_type].present?
        PITCHER_TYPES[pitcher_type][:name]
      end
  end

  def verbose_throws
    @verbose_throws ||= THROWS_MAP[throws][:name] if THROWS_MAP[throws]
  end

  def verbose_bats
    @verbose_bats ||= BATS_MAP[bats][:name] if BATS_MAP[bats]
  end

  def starting_pitcher?
    @starting_pitcher ||= positions.include?(1) && starting_pitching.present?
  end

  def relief_pitcher?
    @relief_pitcher ||= positions.include?(1) && relief_pitching.present?
  end

  def infielder?
    @infielder ||= [3, 4, 5, 6].any? { |pos| positions.include?(pos) }
  end

  def outfielder?
    @outfielder ||= [7, 8].any? { |pos| positions.include?(pos) }
  end

  def plays_position?(pos)
    return false unless pos && POSITION_MAP.keys.include?(pos)

    position_defense(pos).present?
  end

  def roster_level
    @roster_level ||= Roster::LEVEL_MAP[roster.level][:name] if roster&.level
  end

  private

    def build_name
      temp = first_name.to_s
      temp += " \"#{nick_name}\" " if nick_name.present?
      "#{temp} #{last_name}".squish
    end

    def build_primary_position_initials
      return if primary_position.blank?

      if primary_position == 1
        initial = "#{pitcher_type}P".upcase
        return initial unless hitting_pitcher

        "#{initial}+H"
      else
        POSITION_MAP[primary_position][:initials]
      end
    end

    def build_positions
      temp = []
      POSITION_RANGE.each do |position|
        temp << position if plays_position?(position)
      end
      temp
    end
end
