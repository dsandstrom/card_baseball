# frozen_string_literal: true

module UsersHelper
  def user_tags(user)
    return unless user.admin?

    content_tag(:span, 'Admin', class: 'tag user-tag')
  end

  def user_teams(user)
    team_links = user.teams.map do |team|
      url = league_team_path(team.league, team) if can?(:read, team)
      [team.name, url, { id: "user_team_#{team.id}", class: 'user-team' }]
    end
    safe_join(navitize(team_links), ', ')
  end

  def user_dropdown(user)
    options = { class: 'dropdown-menu user-dropdown',
                data: { link: 'user-dropdown-link' } }

    content_tag :div, options do
      concat dropdown_menu_user_container(user)
      concat dropdown_menu_logout_container
    end
  end

  private

    def dropdown_menu_user_container(user)
      content_tag :div, class: 'dropdown-menu-container' do
        concat content_tag(:p, user.email,
                           class: 'user-email dropdown-menu-title')
        concat safe_join(navitize(user_nav_links(user),
                                  class: 'button button-clear'))
      end
    end

    def user_nav_links(user)
      links = [['My Teams', user_path(user)], ['All Users', users_path]]
      return links unless can?(:update, user)

      links.append ['User Settings', edit_user_path(user)]
    end

    def dropdown_menu_logout_container
      content_tag :div, class: 'dropdown-menu-container' do
        safe_join(navitize(log_out_link))
      end
    end

    def log_out_link
      [['Log Out', destroy_user_session_path,
        { method: :delete, class: 'button button-warning button-clear' }]]
    end
end
