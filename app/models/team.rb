# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true
  validates :league_id, presence: true

  belongs_to :league
end
