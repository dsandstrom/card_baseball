# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :league_id, presence: true

  belongs_to :league
  has_many :contracts, dependent: :nullify
  has_many :players, through: :contracts
  has_many :lineups, dependent: :destroy

  def hitters
    players.hitters.order(offensive_rating: :desc)
  end
end
