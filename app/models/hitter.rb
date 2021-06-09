# frozen_string_literal: true

class Hitter < ApplicationRecord
  has_one :hitter_contract
  has_one :team, through: :hitter_contract
end
