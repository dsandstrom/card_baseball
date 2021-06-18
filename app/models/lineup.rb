# frozen_string_literal: true

class Lineup < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: %i[team_id vs with_dh],
                                                 case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: %w[left right] }, allow_nil: true

  belongs_to :team

  def full_name
    @full_name ||= build_full_name
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
