# frozen_string_literal: true

require "rails_helper"

RSpec.describe "rosters/index", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:team) { Fabricate(:team) }

  let(:second_baseman) { Fabricate(:hitter, primary_position: 4) }
  let(:center_fielder) { Fabricate(:hitter, primary_position: 8) }
  let(:relief_pitcher) { Fabricate(:relief_pitcher) }
  let(:starting_pitcher) { Fabricate(:starting_pitcher) }
  let(:catcher) { Fabricate(:hitter, primary_position: 2) }
  let(:players) do
    [second_baseman, center_fielder, catcher, relief_pitcher, starting_pitcher]
  end

  let!(:level1_roster) do
    Fabricate(:roster, team: team, player: second_baseman, level: 1,
                       position: 3)
  end
  let!(:level2_roster) do
    Fabricate(:roster, team: team, player: center_fielder, level: 2,
                       position: 7)
  end
  let!(:level4_roster1) do
    Fabricate(:roster, team: team, player: starting_pitcher, level: 4,
                       position: 1)
  end
  let!(:level4_roster2) do
    Fabricate(:roster, team: team, player: relief_pitcher, level: 4,
                       position: 10)
  end

  before do
    players.each do |player|
      Fabricate(:contract, team: team, player: player)
    end

    assign(:team, team)
    assign(:league, team.league)
  end

  context "for an admin" do
    before { enable_can(view, admin) }

    before(:each) do
      assign(:level1_rosters, team.rosters.where(level: 1))
      assign(:level2_rosters, team.rosters.where(level: 2))
      assign(:level3_rosters, team.rosters.where(level: 3))
      assign(:level4_rosters, team.rosters.where(level: 4))
      assign(:rosterless_players, [catcher])
      assign(:players, players)
    end

    it "renders a level 1 rosters" do
      render

      assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
    end

    it "renders a level 1 position forms" do
      render

      assert_select "#roster_level_1_position_1_new_form"
      assert_select "#roster_level_1_position_3_new_form"
      assert_select "#roster_level_1_position_7_new_form"
      assert_select "#roster_level_1_position_10_new_form"
      assert_select "#roster_level_1_position_3_0_form"
    end

    it "renders a level 2 rosters" do
      render

      assert_select "#rosters_level_2 #roster_#{level2_roster.id}"
    end

    it "renders a level 2 position forms" do
      render

      assert_select "#roster_level_2_position_1_new_form"
      assert_select "#roster_level_2_position_3_new_form"
      assert_select "#roster_level_2_position_7_new_form"
      assert_select "#roster_level_2_position_10_new_form"
      assert_select "#roster_level_2_position_7_0_form"
    end

    it "renders a level 3 rosters" do
      render

      assert_select "#rosters_level_3"
    end

    it "renders a level 3 position forms" do
      render

      assert_select "#roster_level_3_position_1_new_form"
      assert_select "#roster_level_3_position_3_new_form"
      assert_select "#roster_level_3_position_7_new_form"
      assert_select "#roster_level_3_position_10_new_form"
    end

    it "renders a level 4 rosters" do
      render

      assert_select "#rosters_level_4 #roster_#{level4_roster1.id}"
      assert_select "#rosters_level_4 #roster_#{level4_roster2.id}"
    end

    it "renders a level 4 position forms" do
      render

      assert_select "#roster_level_4_position_1_new_form"
      assert_select "#roster_level_4_position_2_new_form"
      assert_select "#roster_level_4_position_3_new_form"
      assert_select "#roster_level_4_position_4_new_form"
      assert_select "#roster_level_4_position_5_new_form"
      assert_select "#roster_level_4_position_6_new_form"
      assert_select "#roster_level_4_position_7_new_form"
      assert_select "#roster_level_4_position_7_new_form"
      assert_select "#roster_level_4_position_8_new_form"
      assert_select "#roster_level_4_position_10_new_form"
      assert_select "#roster_level_4_position_1_0_form"
      assert_select "#roster_level_4_position_10_0_form"
    end

    it "renders rosterless" do
      render

      assert_select "#rosterless_player_#{catcher.id}"
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    context "when it's their team" do
      before(:each) do
        team.update user_id: user.id

        assign(:level1_rosters, team.rosters.where(level: 1))
        assign(:level2_rosters, team.rosters.where(level: 2))
        assign(:level3_rosters, team.rosters.where(level: 3))
        assign(:level4_rosters, team.rosters.where(level: 4))
        assign(:rosterless_players, [catcher])
        assign(:players, players)
      end

      it "renders a level 1 rosters" do
        render

        assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
      end

      it "renders a level 1 position forms" do
        render

        assert_select "#roster_level_1_position_1_new_form"
        assert_select "#roster_level_1_position_3_new_form"
        assert_select "#roster_level_1_position_7_new_form"
        assert_select "#roster_level_1_position_10_new_form"
      end

      it "renders a level 2 rosters" do
        render

        assert_select "#rosters_level_2 #roster_#{level2_roster.id}"
      end

      it "renders a level 2 position forms" do
        render

        assert_select "#roster_level_2_position_1_new_form"
        assert_select "#roster_level_2_position_3_new_form"
        assert_select "#roster_level_2_position_7_new_form"
        assert_select "#roster_level_2_position_10_new_form"
      end

      it "renders a level 3 rosters" do
        render

        assert_select "#rosters_level_3"
      end

      it "renders a level 3 position forms" do
        render

        assert_select "#roster_level_3_position_1_new_form"
        assert_select "#roster_level_3_position_3_new_form"
        assert_select "#roster_level_3_position_7_new_form"
        assert_select "#roster_level_3_position_10_new_form"
      end

      it "renders a level 4 rosters" do
        render

        assert_select "#rosters_level_4 #roster_#{level4_roster1.id}"
        assert_select "#rosters_level_4 #roster_#{level4_roster2.id}"
      end

      it "renders a level 4 position forms" do
        render

        assert_select "#roster_level_4_position_1_new_form"
        assert_select "#roster_level_4_position_2_new_form"
        assert_select "#roster_level_4_position_3_new_form"
        assert_select "#roster_level_4_position_4_new_form"
        assert_select "#roster_level_4_position_5_new_form"
        assert_select "#roster_level_4_position_6_new_form"
        assert_select "#roster_level_4_position_7_new_form"
        assert_select "#roster_level_4_position_7_new_form"
        assert_select "#roster_level_4_position_8_new_form"
        assert_select "#roster_level_4_position_10_new_form"
      end

      it "renders rosterless" do
        render

        assert_select "#rosterless_player_#{catcher.id}"
      end
    end

    context "when it's not their team" do
      before(:each) do
        assign(:level1_rosters, team.rosters.where(level: 1))
        assign(:level2_rosters, team.rosters.where(level: 2))
        assign(:level3_rosters, team.rosters.where(level: 3))
        assign(:level4_rosters, team.rosters.where(level: 4))
        assign(:rosterless_players, [catcher])
        assign(:players, players)
      end

      it "renders a level 1 rosters" do
        render

        assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
      end

      it "doesn't render position forms" do
        render

        assert_select "#roster_level_1_position_1_new_form", count: 0
        assert_select "#roster_level_2_position_3_new_form", count: 0
        assert_select "#roster_level_3_position_7_new_form", count: 0
        assert_select "#roster_level_4_position_2_new_form", count: 0
        assert_select "#roster_level_1_position_3_0_form", count: 0
        assert_select "#roster_level_2_position_7_0_form", count: 0
        assert_select "#roster_level_4_position_1_0_form", count: 0
        assert_select "#roster_level_4_position_10_0_form", count: 0
      end

      it "renders a level 2 rosters" do
        render

        assert_select "#rosters_level_2 #roster_#{level2_roster.id}"
      end

      it "renders a level 3 rosters" do
        render

        assert_select "#rosters_level_3"
      end

      it "renders a level 4 rosters" do
        render

        assert_select "#rosters_level_4 #roster_#{level4_roster1.id}"
        assert_select "#rosters_level_4 #roster_#{level4_roster2.id}"
      end

      it "renders rosterless" do
        render

        assert_select "#rosterless_player_#{catcher.id}"
      end
    end
  end
end
