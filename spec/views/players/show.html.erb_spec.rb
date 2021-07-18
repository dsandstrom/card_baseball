# frozen_string_literal: true

require "rails_helper"

RSpec.describe "players/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:player) { Fabricate(:player) }

  before(:each) do
    @player = assign(:player, player)
  end

  context "for an admin" do
    before { enable_can(view, admin) }

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

    context "without a contract" do
      it "renders new contract link" do
        render

        expect(rendered).to have_link(nil, href: player_contract_path(player))
      end
    end

    context "with a contract" do
      before do
        Fabricate(:contract, player: player)
        assign(:player, player)
      end

      it "renders edit contract link" do
        render

        expect(rendered).to have_link(nil, href: player_contract_path(player))
      end
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    it "renders player's name" do
      render

      assert_select ".player-name", player.name
    end

    it "doesn't render edit link" do
      render

      expect(rendered).not_to have_link(nil, href: edit_player_path(player))
    end

    it "doesn't render destroy link" do
      render

      assert_select "a[href=?][data-method='delete']", player_path(player),
                    count: 0
    end

    context "without a contract" do
      it "doesn't render new contract link" do
        render

        expect(rendered)
          .not_to have_link(nil, href: player_contract_path(player))
      end
    end

    context "with a contract" do
      before do
        Fabricate(:contract, player: player)
        assign(:player, player)
      end

      it "doesn't render edit contract link" do
        render

        expect(rendered)
          .not_to have_link(nil, href: player_contract_path(player))
      end
    end
  end
end
