# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:league) { Fabricate(:league) }
  let(:hitter) { Fabricate(:hitter) }

  before(:each) do
    assign(:league, league)
    assign(:teams, [])
  end

  context "for an admin" do
    before { enable_can(view, admin) }

    it "renders league's name" do
      render
      assert_select ".league-name", league.name
    end

    it "renders edit league link" do
      render

      expect(rendered).to have_link(nil, href: edit_league_path(league))
    end

    it "renders new team link" do
      render

      expect(rendered).to have_link(nil, href: new_league_team_path(league))
    end

    context "when league has teams" do
      let(:team) { Fabricate(:team, league: league) }
      let(:team_path) { league_team_path(league, team) }

      before do
        assign(:teams, [team])
        Fabricate(:contract, team: team, player: hitter)
      end

      it "renders the teams" do
        render

        assert_select "#team_#{team.id}"
        expect(rendered).to have_link(nil, href: team_path)
      end

      it "renders edit team links" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_league_team_path(league, team))
      end

      it "renders destroy team links" do
        render

        assert_select "a[href=?][data-method='delete']", team_path
      end
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    it "renders league's name" do
      render
      assert_select ".league-name", league.name
    end

    it "doesn't render edit league link" do
      render

      expect(rendered).not_to have_link(nil, href: edit_league_path(league))
    end

    it "doesn't render new team link" do
      render

      expect(rendered).not_to have_link(nil, href: new_league_team_path(league))
    end

    context "when league has teams" do
      let(:team) { Fabricate(:team, league: league) }
      let(:user_team) { Fabricate(:team, league: league, user: user) }

      before do
        assign(:teams, [team, user_team])
        Fabricate(:contract, team: team, player: hitter)
      end

      it "renders the teams" do
        render

        assert_select "#team_#{team.id}"
        expect(rendered).to have_link(nil, href: league_team_path(league, team))
        assert_select "#team_#{team.id}"
        expect(rendered)
          .to have_link(nil, href: league_team_path(league, user_team))
      end

      it "renders only own team edit link" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_league_team_path(league, user_team))
        expect(rendered)
          .not_to have_link(nil, href: edit_league_team_path(league, team))
      end

      it "doesn't render destroy team links" do
        render

        assert_select "a[href=?][data-method='delete']",
                      league_team_path(league, team), count: 0
        assert_select "a[href=?][data-method='delete']",
                      league_team_path(league, user_team), count: 0
      end
    end
  end
end
