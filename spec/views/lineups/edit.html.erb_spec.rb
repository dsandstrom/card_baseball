# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/edit", type: :view do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }

  before(:each) do
    assign(:team, team)
    assign(:league, team.league)
    @lineup = assign(:lineup, lineup)
  end

  it "renders the edit lineup form" do
    render

    assert_select "form[action=?][method=?]", team_lineup_path(team, lineup),
                  "post" do
      assert_select "input[name=?]", "lineup[name]"
      assert_select "select[name=?]", "lineup[vs]"
      assert_select "input[name=?]", "lineup[with_dh]"
    end
  end
end
