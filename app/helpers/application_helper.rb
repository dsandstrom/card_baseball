# frozen_string_literal: true

module ApplicationHelper
  def menu_link(text, path)
    klass = 'menu-link'
    klass += ' current-page' if current_page?(path)

    content_tag :p do
      link_to(text, path, class: klass)
    end
  end

  private

    def enable_page_title(title)
      title = "Card Baseball | #{title}"
      content_for(:title, truncate(title, length: 70, omission: ''))
    end
end
