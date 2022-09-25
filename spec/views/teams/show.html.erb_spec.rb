# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:team_user) { Fabricate(:user) }
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league:) }
  let(:player) { Fabricate(:player) }

  context "for an admin" do
    before { enable_can(view, admin) }

    before(:each) do
      Fabricate(:contract, player:, team:)
      @league = assign(:league, league)
      @players = assign(:players, team.players)
    end

    context "when team has no user" do
      let(:team) { Fabricate(:team, league:, user: nil) }

      before(:each) do
        @team = assign(:team, team)
      end

      it "renders team's name" do
        render

        assert_select ".team-name", team.name
      end

      it "renders league link" do
        render

        expect(rendered).to have_link(nil, href: league_path(league))
      end

      it "renders team links" do
        render

        expect(rendered).to have_link(nil, href: team_hitters_path(team))
        expect(rendered).to have_link(nil, href: team_pitchers_path(team))
        expect(rendered).to have_link(nil, href: team_lineups_path(team))
      end

      it "renders edit team link" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_league_team_path(league, team))
      end
    end

    context "when team has a user" do
      let(:team) { Fabricate(:team, league:, user: team_user) }

      before { assign(:team, team) }

      it "renders team user" do
        render

        assert_select ".team-user", team_user.name
      end
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    before(:each) do
      Fabricate(:contract, player:, team:)
      @league = assign(:league, league)
      @players = assign(:players, team.players)
    end

    context "when team belongs to a different user" do
      let(:team) { Fabricate(:team, league:, user: team_user) }

      before { assign(:team, team) }

      it "renders team's name" do
        render

        assert_select ".team-name", team.name
      end

      it "renders team user" do
        render

        assert_select ".team-user", team_user.name
      end

      it "renders league link" do
        render

        expect(rendered).to have_link(nil, href: league_path(league))
      end

      it "renders team links" do
        render

        expect(rendered).to have_link(nil, href: team_hitters_path(team))
        expect(rendered).to have_link(nil, href: team_pitchers_path(team))
        expect(rendered).to have_link(nil, href: team_lineups_path(team))
      end

      it "doesn't render edit team link" do
        render

        expect(rendered)
          .not_to have_link(nil, href: edit_league_team_path(league, team))
      end
    end

    context "when team belongs to the user" do
      let(:team) { Fabricate(:team, league:, user:) }

      before(:each) do
        @team = assign(:team, team)
      end

      it "renders team's name" do
        render

        assert_select ".team-name", team.name
      end

      it "renders team user" do
        render

        assert_select ".team-user", count: 0
      end

      it "renders edit team link" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_league_team_path(league, team))
      end
    end
  end
end
