# frozen_string_literal: true

module HittersHelper
  def format_defense(defense)
    return defense if defense.blank? || defense <= 0

    "+#{defense}"
  end
end
