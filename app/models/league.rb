# frozen_string_literal: true

class League < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :teams, dependent: :nullify

  def full_name
    @full_name ||= "#{name} League"
  end
end
