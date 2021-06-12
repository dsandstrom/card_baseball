# frozen_string_literal: true

class HitterContract < ApplicationRecord
  LENGTH_OPTIONS = [1, 2, 3].freeze

  belongs_to :hitter
  belongs_to :team, optional: true

  validates :hitter_id, presence: true
  validates :length, inclusion: { in: LENGTH_OPTIONS }
end
