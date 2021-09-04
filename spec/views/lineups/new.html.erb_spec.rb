# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/new", type: :view do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate.build(:lineup) }

  before(:each) do
    assign(:team, team)
    assign(:league, team.league)
    assign(:lineup, lineup)
  end

  it "renders new lineup form" do
    render

    assert_select "form[action=?][method=?]", team_lineups_path(team), "post" do
      assert_select "input[name=?]", "lineup[name]"
      assert_select "input[name=?]", "lineup[vs]"
      assert_select "input[name=?]", "lineup[with_dh]"
      assert_select "input[name=?]", "lineup[away]"
    end
  end
end
