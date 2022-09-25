# frozen_string_literal: true

require "rails_helper"

RSpec.describe "rosters/index", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  let(:second_baseman) { Fabricate(:hitter, primary_position: 4) }
  let(:center_fielder) { Fabricate(:hitter, primary_position: 8) }
  let(:relief_pitcher) { Fabricate(:relief_pitcher) }
  let(:starting_pitcher) { Fabricate(:starting_pitcher) }
  let(:catcher) { Fabricate(:hitter, primary_position: 2) }
  let(:players) do
    [second_baseman, center_fielder, catcher, relief_pitcher,
     starting_pitcher]
  end

  context "when showing one team" do
    let(:team) { Fabricate(:team) }

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
      # players.each do |player|
      #   Fabricate(:contract, team: team, player: player)
      # end

      assign(:team, team)
      # assign(:league, team.league)
    end

    context "for an admin" do
      before { enable_can(view, admin) }

      before(:each) do
        assign(:rosters, team.rosters)
        assign(:rosterless_players, [catcher])
        assign(:players, players)
      end

      it "renders a level 1 rosters" do
        render

        assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
      end

      it "renders a level 1 position forms" do
        render

        assert_select "#roster_level_1_position_1_form"
        assert_select "#roster_level_1_position_3_form"
        assert_select "#roster_level_1_position_7_form"
        assert_select "#roster_level_1_position_10_form"
        assert_select "#roster_#{level1_roster.id}_form"
      end

      it "renders a level 2 rosters" do
        render

        assert_select "#rosters_level_2 #roster_#{level2_roster.id}"
      end

      it "renders a level 2 position forms" do
        render

        assert_select "#roster_level_2_position_1_form"
        assert_select "#roster_level_2_position_3_form"
        assert_select "#roster_level_2_position_7_form"
        assert_select "#roster_level_2_position_10_form"
        assert_select "#roster_#{level2_roster.id}_form"
      end

      it "renders a level 3 rosters" do
        render

        assert_select "#rosters_level_3"
      end

      it "renders a level 3 position forms" do
        render

        assert_select "#roster_level_3_position_1_form"
        assert_select "#roster_level_3_position_3_form"
        assert_select "#roster_level_3_position_7_form"
        assert_select "#roster_level_3_position_10_form"
      end

      it "renders a level 4 rosters" do
        render

        assert_select "#rosters_level_4 #roster_#{level4_roster1.id}"
        assert_select "#rosters_level_4 #roster_#{level4_roster2.id}"
      end

      it "renders a level 4 position forms" do
        render

        assert_select "#roster_level_4_position_1_form"
        assert_select "#roster_level_4_position_2_form"
        assert_select "#roster_level_4_position_3_form"
        assert_select "#roster_level_4_position_4_form"
        assert_select "#roster_level_4_position_5_form"
        assert_select "#roster_level_4_position_6_form"
        assert_select "#roster_level_4_position_7_form"
        assert_select "#roster_level_4_position_7_form"
        assert_select "#roster_level_4_position_8_form"
        assert_select "#roster_level_4_position_10_form"
        assert_select "#roster_#{level4_roster1.id}_form"
        assert_select "#roster_#{level4_roster2.id}_form"
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

          assign(:rosters, team.rosters)
          assign(:rosterless_players, [catcher])
          assign(:players, players)
        end

        it "renders a level 1 rosters" do
          render

          assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
        end

        it "renders a level 1 position forms" do
          render

          assert_select "#roster_level_1_position_1_form"
          assert_select "#roster_level_1_position_3_form"
          assert_select "#roster_level_1_position_7_form"
          assert_select "#roster_level_1_position_10_form"
        end

        it "renders a level 2 rosters" do
          render

          assert_select "#rosters_level_2 #roster_#{level2_roster.id}"
        end

        it "renders a level 2 position forms" do
          render

          assert_select "#roster_level_2_position_1_form"
          assert_select "#roster_level_2_position_3_form"
          assert_select "#roster_level_2_position_7_form"
          assert_select "#roster_level_2_position_10_form"
        end

        it "renders a level 3 rosters" do
          render

          assert_select "#rosters_level_3"
        end

        it "renders a level 3 position forms" do
          render

          assert_select "#roster_level_3_position_1_form"
          assert_select "#roster_level_3_position_3_form"
          assert_select "#roster_level_3_position_7_form"
          assert_select "#roster_level_3_position_10_form"
        end

        it "renders a level 4 rosters" do
          render

          assert_select "#rosters_level_4 #roster_#{level4_roster1.id}"
          assert_select "#rosters_level_4 #roster_#{level4_roster2.id}"
        end

        it "renders a level 4 position forms" do
          render

          assert_select "#roster_level_4_position_1_form"
          assert_select "#roster_level_4_position_2_form"
          assert_select "#roster_level_4_position_3_form"
          assert_select "#roster_level_4_position_4_form"
          assert_select "#roster_level_4_position_5_form"
          assert_select "#roster_level_4_position_6_form"
          assert_select "#roster_level_4_position_7_form"
          assert_select "#roster_level_4_position_7_form"
          assert_select "#roster_level_4_position_8_form"
          assert_select "#roster_level_4_position_10_form"
        end

        it "renders rosterless" do
          render

          assert_select "#rosterless_player_#{catcher.id}"
        end
      end

      context "when it's not their team" do
        before(:each) do
          assign(:rosters, team.rosters)
          assign(:rosterless_players, [catcher])
          assign(:players, players)
        end

        it "renders a level 1 rosters" do
          render

          assert_select "#rosters_level_1 #roster_#{level1_roster.id}"
        end

        it "doesn't render position forms" do
          render

          assert_select "#roster_level_1_position_1_form", count: 0
          assert_select "#roster_level_2_position_3_form", count: 0
          assert_select "#roster_level_3_position_7_form", count: 0
          assert_select "#roster_level_4_position_2_form", count: 0
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

          assert_select "#rosterless_player_#{catcher.id}", count: 0
        end
      end
    end
  end

  context "when showing all teams" do
    let(:first_team) { Fabricate(:team) }
    let(:second_team) { Fabricate(:team) }

    let!(:level1_roster) do
      Fabricate(:roster, team: first_team, player: second_baseman, level: 1,
                         position: 3)
    end
    let!(:level2_roster) do
      Fabricate(:roster, team: second_team, player: center_fielder, level: 2,
                         position: 7)
    end
    let!(:level4_roster1) do
      Fabricate(:roster, team: second_team, player: starting_pitcher, level: 4,
                         position: 1)
    end
    let!(:level4_roster2) do
      Fabricate(:roster, team: first_team, player: relief_pitcher, level: 4,
                         position: 10)
    end

    context "for an admin" do
      before do
        enable_can(view, admin)
        assign(:leagues, { first_team.league => [first_team],
                           second_team.league => [second_team] })
      end

      it "renders a level 1 rosters" do
        render

        assert_select "#rosters_team_#{first_team.id}_level_1_position_1"
        assert_select "#rosters_team_#{first_team.id}_level_1_position_3 " \
                      "#roster_#{level1_roster.id}"
        assert_select "#rosters_team_#{second_team.id}_level_2_position_7 " \
                      "#roster_#{level2_roster.id}"
        assert_select "#rosters_team_#{second_team.id}_level_4_position_1 " \
                      "#roster_#{level4_roster1.id}"
        assert_select "#rosters_team_#{first_team.id}_level_4_position_10 " \
                      "#roster_#{level4_roster2.id}"
      end

      it "doesn't render forms" do
        render

        assert_select "#roster_level_1_position_1_form", count: 0
        assert_select "#roster_#{level1_roster.id}_form", count: 0
      end
    end

    context "for a user" do
      before do
        enable_can(view, user)
        first_team.update user: user
        assign(:leagues, { first_team.league => [first_team],
                           second_team.league => [second_team] })
      end

      it "renders a level 1 rosters" do
        render

        assert_select "#rosters_team_#{first_team.id}_level_1_position_1"
        assert_select "#rosters_team_#{first_team.id}_level_1_position_3 " \
                      "#roster_#{level1_roster.id}"
        assert_select "#rosters_team_#{second_team.id}_level_2_position_7 " \
                      "#roster_#{level2_roster.id}"
        assert_select "#rosters_team_#{second_team.id}_level_4_position_1 " \
                      "#roster_#{level4_roster1.id}"
        assert_select "#rosters_team_#{first_team.id}_level_4_position_10 " \
                      "#roster_#{level4_roster2.id}"
      end

      it "doesn't render forms" do
        render

        assert_select "#roster_level_1_position_1_form", count: 0
        assert_select "#roster_#{level1_roster.id}_form", count: 0
      end
    end
  end
end
