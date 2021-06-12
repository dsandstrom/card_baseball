# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/show", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }

  before(:each) do
    @league = assign(:league, league)
    @team = assign(:team, team)
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
