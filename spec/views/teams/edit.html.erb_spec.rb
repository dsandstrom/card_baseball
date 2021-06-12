# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/edit", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }
  let(:path) { league_team_path(league, team) }

  before(:each) do
    assign(:league, league)
    assign(:team, team)
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", path, "post" do
      assert_select "input[name=?]", "team[name]"
      assert_select "input[name=?]", "team[icon]"
    end
  end
end
