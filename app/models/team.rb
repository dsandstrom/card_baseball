# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true
  validates :league_id, presence: true

  belongs_to :league
  has_many :hitter_contracts
  has_many :hitters, through: :hitter_contracts
end