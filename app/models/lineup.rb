# frozen_string_literal: true

# TODO: after update, delete dh spot if with_dh changes to false

class Lineup < ApplicationRecord
  VS_OPTIONS = %w[left right].freeze

  validates :name, presence: true, uniqueness: { scope: %i[team_id vs with_dh],
                                                 case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: VS_OPTIONS }, allow_blank: true

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

    def build_full_name
      return unless name.present?

      temp = name
      temp = "#{temp} vs Lefty" if vs == 'left'
      temp = "#{temp} vs Righty" if vs == 'right'
      temp = "#{temp} (DH)" if with_dh?
      temp
    end
end
