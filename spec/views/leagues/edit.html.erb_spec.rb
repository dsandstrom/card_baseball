# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/edit", type: :view do
  let(:league) { Fabricate(:league) }

  before(:each) do
    @league = assign(:league, league)
  end

  it "renders the edit league form" do
    render

    assert_select "form[action=?][method=?]", league_path(league), "post" do
      assert_select "input[name=?]", "league[name]"
    end
  end
end
