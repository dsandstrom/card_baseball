# frozen_string_literal: true

require "rails_helper"

RSpec.describe "players/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:player) { Fabricate(:hitting_pitcher) }

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

    it "renders player's roster_name" do
      render

      assert_select ".player-roster-name", player.roster_name
    end

    it "renders player's primary_position" do
      render

      assert_select ".player-primary-position", player.primary_position_initials
    end

    it "renders player's bats" do
      render

      assert_select ".player-bats", player.verbose_bats
    end

    it "renders player's speed" do
      render

      assert_select ".player-speed", player.speed.to_s
    end

    it "renders player's throws" do
      render

      assert_select ".player-throws", player.verbose_throws
    end

    it "renders player's offensive_rating" do
      render

      assert_select ".player-offensive-rating", player.offensive_rating.to_s
    end

    it "renders player's offensive_durability" do
      render

      assert_select ".player-offensive-durability",
                    player.offensive_durability.to_s
    end

    it "renders player's left_hitting" do
      render

      assert_select ".player-left-hitting", player.left_hitting.to_s
    end

    it "renders player's right_hitting" do
      render

      assert_select ".player-right-hitting", player.right_hitting.to_s
    end

    it "renders player's left_on_base_percentage" do
      render

      assert_select ".player-left-on-base-percentage",
                    player.left_on_base_percentage.to_s
    end

    it "renders player's right_on_base_percentage" do
      render

      assert_select ".player-right-on-base-percentage",
                    player.right_on_base_percentage.to_s
    end

    it "renders player's left_slugging" do
      render

      assert_select ".player-left-slugging", player.left_slugging.to_s
    end

    it "renders player's right_slugging" do
      render

      assert_select ".player-right-slugging", player.right_slugging.to_s
    end

    it "renders player's left_homerun" do
      render

      assert_select ".player-left-homerun", player.left_homerun.to_s
    end

    it "renders player's right_homerun" do
      render

      assert_select ".player-right-homerun", player.right_homerun.to_s
    end

    it "renders player's pitcher_type" do
      render

      assert_select ".player-pitcher-type", player.verbose_pitcher_type
    end

    it "renders player's pitcher_rating" do
      render

      assert_select ".player-pitcher-rating", player.pitcher_rating.to_s
    end

    it "renders player's relief_pitching" do
      render

      assert_select ".player-relief-pitching", player.relief_pitching.to_s
    end

    it "renders player's starting_pitching" do
      render

      assert_select ".player-starting-pitching", player.starting_pitching.to_s
    end

    it "renders player's pitching_durability" do
      render

      assert_select ".player-pitching-durability",
                    player.pitching_durability.to_s
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
