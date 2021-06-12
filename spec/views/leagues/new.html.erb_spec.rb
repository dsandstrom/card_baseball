# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/new", type: :view do
  let(:league) { Fabricate.build(:league) }

  before(:each) do
    assign(:league, league)
  end

  it "renders new league form" do
    render

    assert_select "form[action=?][method=?]", leagues_path, "post" do
      assert_select "input[name=?]", "league[name]"
    end
  end
end
