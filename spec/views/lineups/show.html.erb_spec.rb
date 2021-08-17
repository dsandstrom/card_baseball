# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:team) { Fabricate(:team) }
  let(:player) { Fabricate(:hitter) }

  before do
    Fabricate(:contract, team: team, player: player)
    Fabricate(:roster, team: team, player: player, level: 4,
                       position: player.primary_position)
  end

  context "for an admin" do
    before { enable_can(view, admin) }

    context "when with_dh is false" do
      let(:lineup) { Fabricate(:lineup, team: team, with_dh: false) }

      before(:each) do
        assign(:team, team)
        assign(:league, team.league)
        @lineup = assign(:lineup, lineup)
        assign(:spots, lineup.spots)
      end

      it "renders lineup's name" do
        render

        assert_select ".lineup-name", lineup.full_name
      end

      it "renders edit lineup link" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_team_lineup_path(team, lineup))
      end

      it "renders spot forms" do
        render

        assert_select "form[action=?]", lineup_spots_path(lineup), count: 8
      end

      it "renders draggable bench hitter" do
        render

        assert_select ".draggable.bench-hitter"
      end
    end

    context "when with_dh is true" do
      let(:lineup) { Fabricate(:lineup, team: team, with_dh: true) }

      before(:each) do
        assign(:team, team)
        assign(:league, team.league)
        @lineup = assign(:lineup, lineup)
        assign(:spots, lineup.spots)
      end

      it "renders lineup's name" do
        render

        assert_select ".lineup-name", lineup.full_name
      end

      it "renders edit lineup link" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_team_lineup_path(team, lineup))
      end

      it "renders spot forms" do
        render

        assert_select "form[action=?]", lineup_spots_path(lineup), count: 9
      end

      it "renders draggable bench hitter" do
        render

        assert_select ".draggable.bench-hitter"
      end
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    context "when their team" do
      let(:team) { Fabricate(:team, user_id: user.id) }

      context "when with_dh is false" do
        let(:lineup) { Fabricate(:lineup, team: team, with_dh: false) }

        before(:each) do
          assign(:team, team)
          assign(:league, team.league)
          @lineup = assign(:lineup, lineup)
          assign(:spots, lineup.spots)
        end

        it "renders lineup's name" do
          render

          assert_select ".lineup-name", lineup.full_name
        end

        it "renders edit lineup link" do
          render

          expect(rendered)
            .to have_link(nil, href: edit_team_lineup_path(team, lineup))
        end

        it "renders spot forms" do
          render

          assert_select "form[action=?]", lineup_spots_path(lineup), count: 8
        end

        it "renders draggable bench hitter" do
          render

          assert_select ".draggable.bench-hitter"
        end
      end

      context "when with_dh is true" do
        let(:lineup) { Fabricate(:lineup, team: team, with_dh: true) }

        before(:each) do
          assign(:team, team)
          assign(:league, team.league)
          @lineup = assign(:lineup, lineup)
          assign(:spots, lineup.spots)
        end

        it "renders lineup's name" do
          render

          assert_select ".lineup-name", lineup.full_name
        end

        it "renders edit lineup link" do
          render

          expect(rendered)
            .to have_link(nil, href: edit_team_lineup_path(team, lineup))
        end

        it "renders spot forms" do
          render

          assert_select "form[action=?]", lineup_spots_path(lineup), count: 9
        end

        it "renders draggable bench hitter" do
          render

          assert_select ".draggable.bench-hitter"
        end
      end
    end

    context "when not their team" do
      let(:team) { Fabricate(:team) }

      context "when with_dh is false" do
        let(:lineup) { Fabricate(:lineup, team: team, with_dh: false) }

        before(:each) do
          assign(:team, team)
          assign(:league, team.league)
          @lineup = assign(:lineup, lineup)
          assign(:spots, lineup.spots)
        end

        it "renders lineup's name" do
          render

          assert_select ".lineup-name", lineup.full_name
        end

        it "doesn't render edit lineup link" do
          render

          expect(rendered)
            .not_to have_link(nil, href: edit_team_lineup_path(team, lineup))
        end

        it "doesn't render spot forms" do
          render

          assert_select "form[action=?]", lineup_spots_path(lineup), count: 0
        end

        it "doesn't render draggable bench hitter" do
          render

          assert_select ".bench-hitter"
          assert_select ".draggable", count: 0
        end
      end

      context "when with_dh is true" do
        let(:lineup) { Fabricate(:lineup, team: team, with_dh: true) }

        before(:each) do
          assign(:team, team)
          assign(:league, team.league)
          @lineup = assign(:lineup, lineup)
          assign(:spots, lineup.spots)
        end

        it "renders lineup's name" do
          render

          assert_select ".lineup-name", lineup.full_name
        end

        it "doesn't render edit lineup link" do
          render

          expect(rendered)
            .not_to have_link(nil, href: edit_team_lineup_path(team, lineup))
        end

        it "doesn't render spot forms" do
          render

          assert_select "form[action=?]", lineup_spots_path(lineup), count: 0
        end

        it "doesn't render draggable bench hitter" do
          render

          assert_select ".bench-hitter"
          assert_select ".draggable", count: 0
        end
      end
    end
  end
end
