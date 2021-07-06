# frozen_string_literal: true

require "rails_helper"

RSpec.describe "players/index", type: :view do
  let(:first_player) { Fabricate(:player) }
  let(:second_player) { Fabricate(:player) }
  let(:first_path) { player_path(first_player) }
  let(:second_path) { player_path(second_player) }

  before(:each) do
    assign(:players, page([first_player, second_player]))
  end

  it "renders a list of players" do
    render

    assert_select "#player_#{first_player.id}"
    expect(rendered).to have_link(nil, href: first_path)

    assert_select "#player_#{second_player.id}"
    expect(rendered).to have_link(nil, href: second_path)
  end

  it "renders new player link" do
    render

    expect(rendered).to have_link(nil, href: new_player_path)
  end
end
