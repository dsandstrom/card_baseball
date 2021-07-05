# frozen_string_literal: true

class League < ApplicationRecord
  include RankedModel

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :teams, dependent: :nullify

  ranks :row_order
end
