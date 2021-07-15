# frozen_string_literal: true

module UsersHelper
  def log_out_link
    link_to 'Log Out', destroy_user_session_path,
            method: :delete, class: 'button button-warning button-clear'
  end
end
