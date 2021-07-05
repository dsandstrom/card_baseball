# frozen_string_literal: true

require "rails_helper"

RSpec.describe "sort_leagues/edit", type: :view do
  let!(:league) { Fabricate(:league) }

  before(:each) do
    Fabricate(:league)
    @league = assign(:league, league)
  end

  it "renders the edit sort_league form" do
    render

    assert_select "form[action=?]", sort_league_path(league) do
      assert_select "select[name=?]", "league[row_order_position]"
    end
  end
end
