# frozen_string_literal: true

class League < ApplicationRecord
  SORT_OPTIONS = %w[down up].freeze

  include RankedModel

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :row_order_position, inclusion: { in: SORT_OPTIONS },
                                 allow_nil: true

  has_many :teams, dependent: :destroy

  ranks :row_order

  def first?
    @first ||= row_order_rank.present? && row_order_rank.zero?
  end

  def last?
    @last ||= row_order_rank.present? && row_order_rank + 1 == League.count
  end
end
