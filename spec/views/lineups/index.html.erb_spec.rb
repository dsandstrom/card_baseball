# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/index", type: :view do
  let(:team) { Fabricate(:team) }
  let(:first_lineup) { Fabricate(:lineup, team: team) }
  let(:second_lineup) { Fabricate(:lineup, team: team) }

  before(:each) do
    assign(:team, team)
    assign(:league, team.league)
    assign(:lineups, [first_lineup, second_lineup])
  end

  it "renders a list of lineups" do
    render

    assert_select "#lineup_#{first_lineup.id}"
    assert_select "#lineup_#{second_lineup.id}"
  end

  it "renders new lineup link" do
    render

    expect(rendered).to have_link(nil, href: new_team_lineup_path(team))
  end
end
