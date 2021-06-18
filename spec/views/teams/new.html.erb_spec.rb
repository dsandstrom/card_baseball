# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/new", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate.build(:team, league: league) }
  let(:path) { league_teams_path(league) }

  before(:each) do
    assign(:league, league)
    assign(:team, team)
  end

  it "renders new team form" do
    render

    assert_select "form[action=?][method=?]", path, "post" do
      assert_select "input[name=?]", "team[name]"
      assert_select "input[name=?]", "team[logo]"
    end
  end
end
