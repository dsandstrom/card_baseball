# frozen_string_literal: true

module LeaguesHelper
  def leagues_nav
    content_tag :p, class: 'page-nav leagues-nav' do
      safe_join(navitize(leagues_nav_links))
    end
  end

  private

    def leagues_nav_links
      [['Leagues', root_path],
       ['Rosters', rosters_path]]
    end
end
