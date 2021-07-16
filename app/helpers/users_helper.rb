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

  def user_teams(user)
    team_links = user.teams.map do |team|
      url = league_team_path(team.league, team) if can?(:read, team)
      [team.name, url, { id: "user_team_#{team.id}", class: 'user-team' }]
    end
    safe_join(navitize(team_links), ', ')
  end
end
