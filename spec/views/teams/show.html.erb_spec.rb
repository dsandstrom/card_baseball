# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/show", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }
  let(:hitter) { Fabricate(:hitter) }

  before(:each) do
    Fabricate(:contract, player: hitter, team: team)

    @league = assign(:league, league)
    @team = assign(:team, team)
    @hitters = assign(:hitters, @team.hitters)
  end

  it "renders team's name" do
    render

    assert_select ".team-name", team.name
  end

  it "renders team links" do
    render

    expect(rendered)
      .to have_link(nil, href: edit_league_team_path(league, team))
  end

  it "renders league links" do
    render

    expect(rendered).to have_link(nil, href: league_path(league))
  end
end
