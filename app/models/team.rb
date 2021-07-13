# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :league_id, presence: true

  belongs_to :league
  has_many :contracts, dependent: :nullify
  has_many :players, through: :contracts
  has_many :lineups, dependent: :destroy

  def hitters
    query = (2..8).map do |position|
      "players.defense#{position} IS NOT NULL"
    end.join(' OR ')
    players.where(query).order(offensive_rating: :desc)
  end
end
