# frozen_string_literal: true

class HitterContract < ApplicationRecord
  LENGTH_OPTIONS = 1..3

  belongs_to :hitter
  belongs_to :team, optional: true

  validates :hitter_id, presence: true
  validates :length, inclusion: { in: LENGTH_OPTIONS }
end
