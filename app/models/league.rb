# frozen_string_literal: true

class League < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :teams, dependent: :nullify
end
