# frozen_string_literal: true

module HittersHelper
  def format_defense(defense, options = {})
    tag = options.delete(:tag) || :span
    if defense.blank?
      content_tag(tag, 'X', merge_class(options, 'defense-missing'))
    elsif defense.negative?
      content_tag(tag, defense, merge_class(options, 'defense-negative'))
    elsif defense.zero?
      content_tag(tag, '±0', merge_class(options, 'defense-neutral'))
    else
      content_tag(tag, "+#{defense}", merge_class(options, 'defense-positive'))
    end
  end

  def format_defense_and_bar(defense, bar, options = {})
    tag = options.delete(:tag) || :td
    return format_defense(defense, options.merge(tag: tag)) if defense.blank?

    defense_tag = format_defense(defense, tag: :span)
    bar_tag = content_tag(:span, "/#{bar}", class: 'defense-bar') if bar
    content_tag(tag, safe_join([defense_tag, bar_tag]), options)
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
