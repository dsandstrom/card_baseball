# frozen_string_literal: true

# TODO: after update, delete dh spot if with_dh changes to false

class Lineup < ApplicationRecord
  VS_OPTIONS = %w[left right].freeze

  validates :name, uniqueness: { scope: %i[team_id vs with_dh],
                                 case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: VS_OPTIONS }, allow_blank: true
  validate :name_or_vs_present

  belongs_to :team
  has_many :spots

  def full_name
    @full_name ||= build_full_name
  end

  def remove_dh_spot
    spots.where('spots.batting_order = ? OR spots.position = ?', 9, 9)
         .destroy_all
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
end
