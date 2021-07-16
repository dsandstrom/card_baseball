# frozen_string_literal: true

module BreadcrumbsHelper
  def breadcrumbs(views = nil)
    return unless views

    content_tag :div, class: 'breadcrumbs' do
      views.each do |text, url, options|
        concat breadcrumb(text, url, options)
      end
    end
  end

  def league_breadcrumbs(league)
    breadcrumbs([['Home', root_path],
                 [league.name, league_path(league)]])
  end

  def league_team_breadcrumbs(league, team, extra = [])
    pages = [['Home', root_path], [league.name, league_path(league)],
             [team.name, league_team_path(league, team)]]
    extra.each { |e| pages << e } if extra.any?
    breadcrumbs(pages)
  end

  def lineup_breadcrumbs(league, team, lineup = nil)
    pages = [['Lineups', team_lineups_path(team)]]
    pages << [lineup.short_name, team_lineup_path(team, lineup)] if lineup
    league_team_breadcrumbs(league, team, pages)
  end

  def hitter_breadcrumbs(hitter = nil)
    pages = [['Home', root_path], ['All Players', players_path]]
    pages << [hitter.name, hitter_path(hitter)] if hitter
    breadcrumbs(pages)
  end

  def player_breadcrumbs(player = nil)
    pages = [['Home', root_path], ['All Players', players_path]]
    pages << [player.name, player_path(player)] if player
    breadcrumbs(pages)
  end

  def user_breadcrumbs(user = nil)
    pages = [['Users', users_path]]
    pages << [user.name, user] if user
    breadcrumbs(pages)
  end

  private

    def project_breadcrumb_item(project)
      [project.name, project_path(project)]
    end

    def breadcrumb(text, url, options = {})
      content_tag :span, class: 'breadcrumb' do
        link_to text, url, options
      end
    end
end
