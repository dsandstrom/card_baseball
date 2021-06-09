require 'rails_helper'

RSpec.describe "hitters/index", type: :view do
  before(:each) do
    assign(:hitters, [
      Hitter.create!(
        first_name: "First Name",
        middle_name: "Middle Name",
        last_name: "Last Name",
        roster_name: "Roster Name",
        bats: "Bats",
        bunt: "Bunt",
        speed: 2,
        durability: 3,
        overall_rating: 4,
        left_rating: 5,
        right_rating: 6,
        left_on_base_percentage: 7,
        left_slugging: 8,
        left_homeruns: 9,
        right_on_base_percentage: 10,
        right_slugging: 11,
        right_homeruns: 12,
        catcher_defense: 13,
        first_base_defense: 14,
        second_base_defense: 15,
        third_base_defense: 16,
        short_stop_defense: 17,
        center_field_defense: 18,
        outfield_defense: 19,
        pitcher_defense: 20,
        catcher_bar: 21,
        pitcher_bar: 22
      ),
      Hitter.create!(
        first_name: "First Name",
        middle_name: "Middle Name",
        last_name: "Last Name",
        roster_name: "Roster Name",
        bats: "Bats",
        bunt: "Bunt",
        speed: 2,
        durability: 3,
        overall_rating: 4,
        left_rating: 5,
        right_rating: 6,
        left_on_base_percentage: 7,
        left_slugging: 8,
        left_homeruns: 9,
        right_on_base_percentage: 10,
        right_slugging: 11,
        right_homeruns: 12,
        catcher_defense: 13,
        first_base_defense: 14,
        second_base_defense: 15,
        third_base_defense: 16,
        short_stop_defense: 17,
        center_field_defense: 18,
        outfield_defense: 19,
        pitcher_defense: 20,
        catcher_bar: 21,
        pitcher_bar: 22
      )
    ])
  end

  it "renders a list of hitters" do
    render
    assert_select "tr>td", text: "First Name".to_s, count: 2
    assert_select "tr>td", text: "Middle Name".to_s, count: 2
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "Roster Name".to_s, count: 2
    assert_select "tr>td", text: "Bats".to_s, count: 2
    assert_select "tr>td", text: "Bunt".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: 5.to_s, count: 2
    assert_select "tr>td", text: 6.to_s, count: 2
    assert_select "tr>td", text: 7.to_s, count: 2
    assert_select "tr>td", text: 8.to_s, count: 2
    assert_select "tr>td", text: 9.to_s, count: 2
    assert_select "tr>td", text: 10.to_s, count: 2
    assert_select "tr>td", text: 11.to_s, count: 2
    assert_select "tr>td", text: 12.to_s, count: 2
    assert_select "tr>td", text: 13.to_s, count: 2
    assert_select "tr>td", text: 14.to_s, count: 2
    assert_select "tr>td", text: 15.to_s, count: 2
    assert_select "tr>td", text: 16.to_s, count: 2
    assert_select "tr>td", text: 17.to_s, count: 2
    assert_select "tr>td", text: 18.to_s, count: 2
    assert_select "tr>td", text: 19.to_s, count: 2
    assert_select "tr>td", text: 20.to_s, count: 2
    assert_select "tr>td", text: 21.to_s, count: 2
    assert_select "tr>td", text: 22.to_s, count: 2
  end
end
