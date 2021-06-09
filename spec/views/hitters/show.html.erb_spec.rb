# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitters/show", type: :view do
  before(:each) do
    @hitter = assign(:hitter, Hitter.create!(
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
                              ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Middle Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Roster Name/)
    expect(rendered).to match(/Bats/)
    expect(rendered).to match(/Bunt/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/11/)
    expect(rendered).to match(/12/)
    expect(rendered).to match(/13/)
    expect(rendered).to match(/14/)
    expect(rendered).to match(/15/)
    expect(rendered).to match(/16/)
    expect(rendered).to match(/17/)
    expect(rendered).to match(/18/)
    expect(rendered).to match(/19/)
    expect(rendered).to match(/20/)
    expect(rendered).to match(/21/)
    expect(rendered).to match(/22/)
  end
end
