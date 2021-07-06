# frozen_string_literal: true

require "rails_helper"

RSpec.describe "players/edit", type: :view do
  let(:player) { Fabricate(:player) }

  before(:each) do
    @player = assign(:player, player)
  end

  it "renders the edit player form" do
    render

    assert_select "form[action=?][method=?]", player_path(@player), "post" do
      assert_select "input[name=?]", "player[first_name]"
      assert_select "input[name=?]", "player[nick_name]"
      assert_select "input[name=?]", "player[last_name]"
      assert_select "input[name=?]", "player[roster_name]"

      assert_select "select[name=?]", "player[bats]"
      assert_select "select[name=?]", "player[bunt_grade]"
      assert_select "select[name=?]", "player[primary_position]"
      assert_select "input[name=?]", "player[hitting_pitcher]"

      assert_select "input[name=?]", "player[speed]"
      assert_select "input[name=?]", "player[offensive_durability]"
      assert_select "input[name=?]", "player[offensive_rating]"
      assert_select "input[name=?]", "player[left_hitting]"
      assert_select "input[name=?]", "player[right_hitting]"
      assert_select "input[name=?]", "player[left_on_base_percentage]"
      assert_select "input[name=?]", "player[left_slugging]"
      assert_select "input[name=?]", "player[left_homerun]"
      assert_select "input[name=?]", "player[right_on_base_percentage]"
      assert_select "input[name=?]", "player[right_slugging]"
      assert_select "input[name=?]", "player[right_homerun]"
      assert_select "input[name=?]", "player[defense1]"
      assert_select "input[name=?]", "player[defense2]"
      assert_select "input[name=?]", "player[defense3]"
      assert_select "input[name=?]", "player[defense4]"
      assert_select "input[name=?]", "player[defense5]"
      assert_select "input[name=?]", "player[defense6]"
      assert_select "input[name=?]", "player[defense7]"
      assert_select "input[name=?]", "player[defense8]"
      assert_select "input[name=?]", "player[bar1]"
      assert_select "input[name=?]", "player[bar2]"
    end
  end
end
