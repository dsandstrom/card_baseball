# frozen_string_literal: true

class Lineup < ApplicationRecord
  validates :name, presence: true,
                   uniqueness: { scope: :team_id, case_sensitive: false }
  validates :team_id, presence: true
  # nil vs = either side
  validates :vs, inclusion: { in: %w[left right] }, allow_nil: true

  belongs_to :team
end
