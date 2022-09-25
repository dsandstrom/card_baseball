# frozen_string_literal: true

require "rails_helper"

RSpec.describe "spots/edit", type: :view do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team:) }
  let(:spot) { Fabricate(:spot, lineup:) }

  before(:each) do
    assign(:lineup, lineup)
    assign(:team, team)
    assign(:league, team.league)
    assign(:spot, spot)
  end

  it "renders the edit spot form" do
    render

    url = lineup_spot_path(lineup, spot)

    assert_select "form[action=?][method=?]", url, "post" do
      assert_select "select[name=?]", "spot[hitter_id]"
      assert_select "select[name=?]", "spot[position]"
      assert_select "input[name=?]", "spot[batting_order]"
    end
  end
end
