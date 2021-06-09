require 'rails_helper'

RSpec.describe "hitters/edit", type: :view do
  before(:each) do
    @hitter = assign(:hitter, Hitter.create!(
      first_name: "MyString",
      middle_name: "MyString",
      last_name: "MyString",
      roster_name: "MyString",
      bats: "MyString",
      bunt: "MyString",
      speed: 1,
      durability: 1,
      overall_rating: 1,
      left_rating: 1,
      right_rating: 1,
      left_on_base_percentage: 1,
      left_slugging: 1,
      left_homeruns: 1,
      right_on_base_percentage: 1,
      right_slugging: 1,
      right_homeruns: 1,
      catcher_defense: 1,
      first_base_defense: 1,
      second_base_defense: 1,
      third_base_defense: 1,
      short_stop_defense: 1,
      center_field_defense: 1,
      outfield_defense: 1,
      pitcher_defense: 1,
      catcher_bar: 1,
      pitcher_bar: 1
    ))
  end

  it "renders the edit hitter form" do
    render

    assert_select "form[action=?][method=?]", hitter_path(@hitter), "post" do

      assert_select "input[name=?]", "hitter[first_name]"

      assert_select "input[name=?]", "hitter[middle_name]"

      assert_select "input[name=?]", "hitter[last_name]"

      assert_select "input[name=?]", "hitter[roster_name]"

      assert_select "input[name=?]", "hitter[bats]"

      assert_select "input[name=?]", "hitter[bunt]"

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

      assert_select "input[name=?]", "hitter[short_stop_defense]"

      assert_select "input[name=?]", "hitter[center_field_defense]"

      assert_select "input[name=?]", "hitter[outfield_defense]"

      assert_select "input[name=?]", "hitter[pitcher_defense]"

      assert_select "input[name=?]", "hitter[catcher_bar]"

      assert_select "input[name=?]", "hitter[pitcher_bar]"
    end
  end
end
