require "rails_helper"

RSpec.describe "rosters/index", type: :view do
  before(:each) do
    assign(:rosters, [
             Roster.create!,
             Roster.create!
           ])
  end

  it "renders a list of rosters" do
    render
  end
end
