# frozen_string_literal: true

# TODO: validate throws presence when pitcher

class Player < ApplicationRecord # rubocop:disable Metrics/ClassLength
  BATS_OPTIONS = %w[R L B].freeze
  THROWS_OPTIONS = %w[L R].freeze
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
  PITCHING_TYPES = {
    'R' => { name: 'Reliever', key: :relief },
    'S' => { name: 'Starter', key: :starting }
  }.freeze

  validates :first_name, length: { maximum: 200 }
  validates :nick_name, length: { maximum: 200 }
  validates :last_name, presence: true, length: { maximum: 200 }
  validates :roster_name, presence: true, length: { maximum: 200 },
                          uniqueness: { case_sensitive: false }
  validates :bats, presence: true, inclusion: { in: BATS_OPTIONS }
  validates :throws, inclusion: { in: THROWS_OPTIONS }, allow_nil: true
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
  validates :pitcher_type, inclusion: { in: PITCHING_TYPES.keys },
                           allow_nil: true
  validates :starting_pitching, inclusion: { in: RATING_RANGE }, allow_nil: true
  validates :relief_pitching, inclusion: { in: RATING_RANGE }, allow_nil: true

  has_one :contract
  has_one :team, through: :contract
  has_many :spots, foreign_key: :hitter_id, dependent: :destroy
  has_many :lineups, through: :spots

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
    query = 'players.pitcher_rating IS NOT NULL'\
            ' AND players.defense1 IS NOT NULL'
    Player.where(query)
  end

  def self.filter_by(filters = {})
    players = all
    players = players.filter_by_name(filters[:query])
    players = players.filter_by_free_agency(filters[:free_agent])
    players = players.filter_by_positions(filters)
    players = players.filter_by_bats(filters[:bats])
    players = players.filter_by_bunt_grade(filters[:bunt_grade])
    players = players.filter_by_speed(filters[:speed])
    players.order(build_order_param(filters[:order]))
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

  # used by .filter_by
  # TODO: add pitcher type radios
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
      if PITCHING_TYPES[pitcher_type].present?
        PITCHING_TYPES[pitcher_type][:name]
      end
  end

  def verbose_throws
    @verbose_throws ||=
      case throws
      when 'L'
        'Left'
      when 'R'
        'Right'
      end
  end

  def verbose_bats
    @verbose_bats ||=
      case bats
      when 'L'
        'Left'
      when 'R'
        'Right'
      when 'B', 'S'
        'Switch'
      end
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
