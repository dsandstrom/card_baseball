# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/show", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }
  let(:player) { Fabricate(:player) }

  before(:each) do
    Fabricate(:contract, player: player, team: team)

    @league = assign(:league, league)
    @team = assign(:team, team)
    @players = assign(:players, @team.players)
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
