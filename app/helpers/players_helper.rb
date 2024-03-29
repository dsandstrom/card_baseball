# frozen_string_literal: true

module PlayersHelper
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
    return format_defense(defense, options.merge(tag:)) if defense.blank?

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

  def player_positions(player, options = {})
    skip = options.delete(:skip)
    position_tags = player.positions.filter_map do |position|
      next if skip&.include?(position)

      player_position_tag(player, position, options)
    end

    safe_join(position_tags)
  end

  def format_pitching(rating, options = {})
    tag = options.delete(:tag) || :span
    category =
      if rating.present?
        "#{rating / 10}0"
      else
        'missing'
      end
    rating ||= 'X'
    content_tag(tag, rating, class: "rating-#{category}")
  end

  def format_hitting(rating, options = {})
    tag = options.delete(:tag) || :span
    category =
      if rating.present?
        "#{rating / 10}0"
      else
        'missing'
      end
    rating ||= 'X'
    content_tag(tag, rating, class: "rating-#{category}")
  end

  private

    def merge_class(options, new_class)
      options[:class] ||= ''
      options[:class] += " #{new_class}" if new_class.present?
      options
    end

    def player_position_tag(player, position, options = {})
      defense = player.position_defense(position)
      bar = player.position_bar(position)
      word = player_position_word(position, options[:full])

      tag_options = { class: 'player-position-defense', tag: :span }
      content_tag :span, class: 'player-position' do
        safe_join([word, format_defense_and_bar(defense, bar, tag_options)])
      end
    end

    def player_position_word(position, full)
      if full
        Player.position_name(position)
      else
        Player.position_initials(position)
      end
    end
end
