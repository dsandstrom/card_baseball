# frozen_string_literal: true

module UsersHelper
  def log_out_link
    link_to 'Log Out', destroy_user_session_path,
            method: :delete, class: 'button button-warning button-clear'
  end

  def user_tags(user)
    return unless user.admin?

    content_tag(:span, 'Admin', class: 'tag user-tag')
  end
end
