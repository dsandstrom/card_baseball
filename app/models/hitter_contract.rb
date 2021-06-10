# frozen_string_literal: true

class HitterContract < ApplicationRecord
  LENGTH_OPTIONS = [1, 2, 3, 4, 5].freeze

  belongs_to :hitter
  belongs_to :team

  validates :hitter_id, presence: true
  validates :length, inclusion: { in: LENGTH_OPTIONS }
end
