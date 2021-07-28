require "rails_helper"

RSpec.describe "rosters/edit", type: :view do
  before(:each) do
    @roster = assign(:roster, Roster.create!)
  end

  it "renders the edit roster form" do
    render

    assert_select "form[action=?][method=?]", roster_path(@roster), "post" do
    end
  end
end
