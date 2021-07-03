# frozen_string_literal: true

module LineupsHelper
  def format_lineup_defense(defense, options = {})
    tag = options.delete(:tag) || :span
    options = merge_class(options, lineup_defense_class_adder(defense))
    value = defense.blank? ? 'X' : defense

    content_tag(tag, value, options)
  end

  private

    def lineup_defense_class_adder(defense)
      if defense.blank? || defense <= 0
        'defense-insufficient'
      elsif defense < 40
        'defense-low'
      elsif defense < 50
        'defense-close'
      else
        'defense-sufficient'
      end
    end
end
