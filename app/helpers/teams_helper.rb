# frozen_string_literal: true

module TeamsHelper
  def team_nav(team)
    content_tag :p, class: 'page-nav team-nav' do
      safe_join(navitize(team_nav_links(team)))
    end
  end

  private

    def team_nav_links(team)
      [['Team', league_team_path(team.league, team)],
       ['Hitters', team_hitters_path(team)],
       ['Pitchers', '#team_pitchers_path(team)'],
       ['Lineups', team_lineups_path(team)]]
    end
end
