# frozen_string_literal: true

require "rails_helper"

RSpec.describe "rosters/new", type: :view do
  let(:team) { Fabricate(:team) }
  let(:roster) { Fabricate.build(:roster, team: team) }

  before(:each) do
    assign(:team, team)
    assign(:league, team.league)
    assign(:roster, roster)
  end

  it "renders new roster form" do
    render

    url = team_rosters_url(team)

    assert_select "form[action=?][method=?]", url, "post" do
      assert_select "select[name=?]", "roster[level]"
      assert_select "select[name=?]", "roster[player_id]"
      assert_select "select[name=?]", "roster[position]"
    end
  end
end
