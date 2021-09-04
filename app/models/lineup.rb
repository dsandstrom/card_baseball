# frozen_string_literal: true

# TODO: allow locking/unlocking
# TODO: allow pitcher from rotation/bullpen to be moved to pitcher spot

class Lineup < ApplicationRecord
  VS_OPTIONS = %w[left right].freeze
  HOME_DEFENSE_ADVANTAGE = 6

  validates :name, uniqueness: { scope: %i[team_id vs with_dh away],
                                 case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: VS_OPTIONS }, allow_blank: true

  belongs_to :team
  has_many :spots, -> { order('batting_order asc') }, dependent: :destroy
  has_many :players, through: :spots

  after_update :fix_dh_spot
  after_save :fix_pitcher_spot

  def full_name
    @full_name ||= build_full_name
  end

  def short_name
    @short_name ||= build_short_name
  end

  def remove_dh_spot
    spots.where('spots.batting_order = ? OR spots.position = ?', 9, 9)
         .destroy_all
  end

  def bench
    @bench ||= team.hitters.joins(:roster)
                   .where('rosters.level = ?', 4)
                   .where.not(id: players.map(&:id))
  end

  def position_form_options
    @position_form_options ||= build_position_form_options
  end

  def spots_at_position(position, current_spot_id = nil)
    pos_spots = spots.where(position: position)
    pos_spots = pos_spots.where.not(id: current_spot_id) if current_spot_id
    pos_spots
  end

  def complete?
    spots.count == 9
  end

  def defense
    @defense ||= build_defense
  end

  def catcher_bar
    @catcher_bar ||= build_catcher_bar
  end

  private

    def fix_dh_spot
      remove_dh_spot unless with_dh?
    end

    def fix_pitcher_spot
      pitcher_spot = spots.find_by(position: 1)

      if with_dh?
        pitcher_spot&.destroy
      elsif !pitcher_spot
        spots.where(batting_order: 9).destroy_all
        spots.create!(position: 1, batting_order: 9)
      end
    end

    def build_full_name
      return unless name.present? || vs.present?

      temp = "#{name} Lineup "
      case vs
      when 'left'
        temp += 'vs Lefty '
      when 'right'
        temp += 'vs Righty '
      end
      temp += '(DH)' if with_dh?
      temp.squish
    end

    def build_short_name
      return unless name.present? || vs.present?

      temp = "#{name} "
      case vs
      when 'left'
        temp += 'vs Lefty '
      when 'right'
        temp += 'vs Righty '
      end
      temp += '(DH)' if with_dh?
      temp.squish
    end

    def build_position_form_options
      options =
        [2, 3, 4, 5, 6, 7, 8].map do |position|
          [Player::POSITION_MAP[position][:initials], position]
        end
      return options unless with_dh

      options << [Player::POSITION_MAP[9][:initials], 9]
    end

    def build_defense
      total = away? ? 0 : HOME_DEFENSE_ADVANTAGE
      spot_defenses = spots.map(&:defense).compact
      return total unless spot_defenses&.any?

      total + spot_defenses.inject(:+)
    end

    def build_catcher_bar
      catcher_spot = spots_at_position(2).first
      catcher_spot&.player&.bar2 || 0
    end
end
