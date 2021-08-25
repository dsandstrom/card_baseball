# frozen_string_literal: true

# TODO: when contract changes, destroy rosters and lineup spots

class Contract < ApplicationRecord
  LENGTH_OPTIONS = 1..3

  belongs_to :player
  belongs_to :team, optional: true

  validates :player_id, presence: true
  validates :length, inclusion: { in: LENGTH_OPTIONS }
end
