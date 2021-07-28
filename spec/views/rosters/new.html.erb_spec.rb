require "rails_helper"

RSpec.describe "rosters/new", type: :view do
  before(:each) do
    assign(:roster, Roster.new)
  end

  it "renders new roster form" do
    render

    assert_select "form[action=?][method=?]", rosters_path, "post" do
    end
  end
end
