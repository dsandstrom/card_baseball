# frozen_string_literal: true

class Spot < ApplicationRecord
  validates :lineup_id, presence: true
  validates :hitter_id, presence: true, uniqueness: { scope: :lineup_id }
  # 2(c)-9(dh)
  validates :position, presence: true, inclusion: { in: 2..9 },
                       uniqueness: { scope: :lineup_id }
  validates :batting_order, presence: true, inclusion: { in: 1..9 },
                            uniqueness: { scope: :lineup_id }

  belongs_to :lineup
  belongs_to :hitter
end