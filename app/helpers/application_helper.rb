# frozen_string_literal: true

module ApplicationHelper
  def menu_link(text, path)
    klass = 'menu-link'
    klass += ' current-page' if current_page?(path)

    content_tag :p do
      link_to(text, path, class: klass)
    end
  end

  def divider
    content_tag :span, '|', class: 'divider'
  end

  def left_td(value, options = {})
    options[:class] ||= 'vs-left'
    options[:class] += ' highlight' if options.delete(:highlight) == 'left'
    content_tag :td, value, options
  end

  def right_td(value, options = {})
    options[:class] ||= 'vs-right'
    options[:class] += ' highlight' if options.delete(:highlight) == 'right'
    content_tag :td, value, options
  end

  private

    def enable_page_title(title)
      title = "Card Baseball | #{title}"
      content_for(:title, truncate(title, length: 70, omission: ''))
    end

    def navitize(links, link_options = {})
      links.map do |value, url, options = {}|
        if link_options[:class]
          options[:class] = "#{link_options[:class]} #{options[:class]}"
        end
        options.reverse_merge! link_options
        if current_page?(url)
          options[:class] = "#{options[:class]} current-page"
        end
        link_to value, url, options
      end
    end
end
