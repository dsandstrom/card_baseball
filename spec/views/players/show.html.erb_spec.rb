# frozen_string_literal: true

require "rails_helper"

RSpec.describe "players/show", type: :view do
  let(:player) { Fabricate(:player) }

  before(:each) do
    @player = assign(:player, player)
  end

  it "renders player's name" do
    render

    assert_select ".player-name", player.name
  end

  it "renders edit link" do
    render

    expect(rendered).to have_link(nil, href: edit_player_path(player))
  end

  it "renders destroy link" do
    render

    assert_select "a[href='#{player_path(player)}'][data-method='delete']"
  end
end
