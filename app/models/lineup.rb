# frozen_string_literal: true

# TODO: after update, delete dh spot if with_dh changes to false
# TODO: allow locking/unlocking

class Lineup < ApplicationRecord
  VS_OPTIONS = %w[left right].freeze

  validates :name, uniqueness: { scope: %i[team_id vs with_dh],
                                 case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: VS_OPTIONS }, allow_blank: true
  validate :name_or_vs_present

  belongs_to :team
  has_many :spots, -> { order('batting_order asc') }, dependent: :destroy
  has_many :hitters, through: :spots

  def full_name
    @full_name ||= build_full_name
  end

  def remove_dh_spot
    spots.where('spots.batting_order = ? OR spots.position = ?', 9, 9)
         .destroy_all
  end

  def bench
    team.hitters.where.not(id: hitters.map(&:id))
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
    complete_count = with_dh? ? 9 : 8
    spots.count == complete_count
  end

  def defense
    spot_defenses = spots.map(&:defense).compact
    return 0 unless spot_defenses&.any?

    spot_defenses.inject(:+)
  end

  private

    def name_or_vs_present
      return if name.present? || vs.present?

      errors.add(:base, 'Name or vs is required')
    end

    def build_full_name
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
          [Hitter::POSITION_OPTIONS[position][:initials], position]
        end
      return options unless with_dh

      options << ['DH', 9]
    end
end
