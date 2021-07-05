# frozen_string_literal: true

class League < ApplicationRecord
  include RankedModel

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :teams, dependent: :nullify

  ranks :row_order

  def first?
    @first ||= row_order_rank.present? && row_order_rank.zero?
  end

  def last?
    @last ||= row_order_rank.present? && row_order_rank + 1 == League.count
  end
end
