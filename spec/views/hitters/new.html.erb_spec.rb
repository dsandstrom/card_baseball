# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitters/new", type: :view do
  let(:hitter) { Fabricate.build(:hitter) }
  before(:each) do
    assign(:hitter, hitter)
  end

  it "renders new hitter form" do
    render

    assert_select "form[action=?][method=?]", hitters_path, "post" do
      assert_select "input[name=?]", "hitter[first_name]"
      assert_select "input[name=?]", "hitter[middle_name]"
      assert_select "input[name=?]", "hitter[last_name]"
      assert_select "input[name=?]", "hitter[roster_name]"

      assert_select "select[name=?]", "hitter[bats]"
      assert_select "select[name=?]", "hitter[bunt_grade]"

      assert_select "select[name=?]", "hitter[primary_position]"
      assert_select "input[name=?]", "hitter[hitting_pitcher]"

      assert_select "input[name=?]", "hitter[speed]"
      assert_select "input[name=?]", "hitter[durability]"
      assert_select "input[name=?]", "hitter[overall_rating]"
      assert_select "input[name=?]", "hitter[left_rating]"
      assert_select "input[name=?]", "hitter[right_rating]"
      assert_select "input[name=?]", "hitter[left_on_base_percentage]"
      assert_select "input[name=?]", "hitter[left_slugging]"
      assert_select "input[name=?]", "hitter[left_homeruns]"
      assert_select "input[name=?]", "hitter[right_on_base_percentage]"
      assert_select "input[name=?]", "hitter[right_slugging]"
      assert_select "input[name=?]", "hitter[right_homeruns]"
      assert_select "input[name=?]", "hitter[catcher_defense]"
      assert_select "input[name=?]", "hitter[first_base_defense]"
      assert_select "input[name=?]", "hitter[second_base_defense]"
      assert_select "input[name=?]", "hitter[third_base_defense]"
      assert_select "input[name=?]", "hitter[shortstop_defense]"
      assert_select "input[name=?]", "hitter[center_field_defense]"
      assert_select "input[name=?]", "hitter[outfield_defense]"
      assert_select "input[name=?]", "hitter[pitcher_defense]"
      assert_select "input[name=?]", "hitter[catcher_bar]"
      assert_select "input[name=?]", "hitter[pitcher_bar]"
    end
  end
end
