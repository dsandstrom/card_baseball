# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/edit", type: :view do
  before(:each) do
    @team = assign(:team, Team.create!(
                            name: "MyString",
                            icon: "MyString",
                            league_id: 1
                          ))
  end

  it "renders the edit team form" do
    render

    assert_select "form[action=?][method=?]", team_path(@team), "post" do
      assert_select "input[name=?]", "team[name]"

      assert_select "input[name=?]", "team[icon]"

      assert_select "input[name=?]", "team[league_id]"
    end
  end
end
