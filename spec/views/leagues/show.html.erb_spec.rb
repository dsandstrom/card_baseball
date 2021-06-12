# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/show", type: :view do
  let(:league) { Fabricate(:league) }

  before(:each) do
    assign(:league, league)
    assign(:teams, [])
  end

  it "renders league's name" do
    render
    assert_select ".league-name", "#{league.name} League"
  end

  it "renders new team link" do
    render

    expect(rendered).to have_link(nil, href: new_league_team_path(league))
  end

  it "renders league links" do
    render

    expect(rendered).to have_link(nil, href: edit_league_path(league))
  end

  context "when league has teams" do
    let(:team) { Fabricate(:team, league: league) }
    let(:team_path) { league_team_path(league, team) }

    before { assign(:teams, [team]) }

    it "renders the teams" do
      render

      assert_select "#team_#{team.id}"
      expect(rendered).to have_link(nil, href: team_path)
      expect(rendered)
        .to have_link(nil, href: edit_league_team_path(league, team))
      assert_select "a[href='#{team_path}'][data-method='delete']"
    end
  end
end
