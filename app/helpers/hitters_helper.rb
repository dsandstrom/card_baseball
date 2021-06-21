# frozen_string_literal: true

module HittersHelper
  def format_defense(defense, options = {})
    tag = options.delete(:tag) || :span
    if defense.blank?
      return content_tag(tag, 'X', merge_class(options, 'defense-missing'))
    end
    if defense <= 0
      return content_tag(tag, defense, merge_class(options, 'defense-negative'))
    end

    content_tag(tag, "+#{defense}", merge_class(options, 'defense-positive'))
  end

  def format_defense_and_bar(defense, bar, options = {})
    return format_defense(defense, options.merge(tag: :td)) if defense.blank?

    options[:class] +=
      if defense.positive?
        ' defense-positive'
      else
        ' defense-negative'
      end

    defense_tag = format_defense(defense, tag: :span)
    bar_tag = content_tag(:span, "/#{bar}", class: 'defense-bar') if bar
    content_tag(:td, safe_join([defense_tag, bar_tag]), options)
  end

  def defense_td(defense, bar = nil, options = {})
    options[:tag] ||= :td
    if defense.present? && bar.present?
      format_defense_and_bar(defense, bar, options)
    else
      format_defense(defense, options)
    end
  end

  private

    def merge_class(options, new_class)
      options[:class] ||= ''
      options[:class] += " #{new_class}" if new_class.present?
      options
    end
end
