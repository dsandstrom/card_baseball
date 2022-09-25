# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/index", type: :view do
  let(:team) { Fabricate(:team) }
  let(:first_lineup) { Fabricate(:lineup, team:) }
  let(:second_lineup) { Fabricate(:lineup, team:) }
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }

  context "for an admin" do
    before { enable_can(view, admin) }

    before(:each) do
      assign(:team, team)
      assign(:league, team.league)
      assign(:lineups, [first_lineup, second_lineup])
    end

    it "renders a list of lineups" do
      render

      assert_select "#lineup_#{first_lineup.id}"
      assert_select "#lineup_#{second_lineup.id}"
    end

    it "renders edit lineup links" do
      render

      expect(rendered)
        .to have_link(nil, href: edit_team_lineup_path(team, first_lineup))
      expect(rendered)
        .to have_link(nil, href: edit_team_lineup_path(team, second_lineup))
    end

    it "renders destroy lineup links" do
      render

      assert_select "a[data-method='delete'][href=?]",
                    team_lineup_path(team, first_lineup)
      assert_select "a[data-method='delete'][href=?]",
                    team_lineup_path(team, second_lineup)
    end

    it "renders new lineup link" do
      render

      expect(rendered).to have_link(nil, href: new_team_lineup_path(team))
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    context "when their team" do
      let(:team) { Fabricate(:team, user_id: user.id) }
      let(:lineup) { Fabricate(:lineup, team:) }

      before(:each) do
        assign(:team, team)
        assign(:league, team.league)
        assign(:lineups, [first_lineup, second_lineup])
      end

      it "renders a list of lineups" do
        render

        assert_select "#lineup_#{first_lineup.id}"
        assert_select "#lineup_#{second_lineup.id}"
      end

      it "renders edit lineup links" do
        render

        expect(rendered)
          .to have_link(nil, href: edit_team_lineup_path(team, first_lineup))
        expect(rendered)
          .to have_link(nil, href: edit_team_lineup_path(team, second_lineup))
      end

      it "renders destroy lineup links" do
        render

        assert_select "a[data-method='delete'][href=?]",
                      team_lineup_path(team, first_lineup)
        assert_select "a[data-method='delete'][href=?]",
                      team_lineup_path(team, second_lineup)
      end

      it "renders new lineup link" do
        render

        expect(rendered).to have_link(nil, href: new_team_lineup_path(team))
      end
    end

    context "when not their team" do
      let(:team) { Fabricate(:team) }
      let(:lineup) { Fabricate(:lineup, team:) }

      before(:each) do
        assign(:team, team)
        assign(:league, team.league)
        assign(:lineups, [first_lineup, second_lineup])
      end

      it "renders a list of lineups" do
        render

        assert_select "#lineup_#{first_lineup.id}"
        assert_select "#lineup_#{second_lineup.id}"
      end

      it "doesn't render edit lineup links" do
        render

        first_url = edit_team_lineup_path(team, first_lineup)
        second_url = edit_team_lineup_path(team, second_lineup)
        expect(rendered).not_to have_link(nil, href: first_url)
        expect(rendered).not_to have_link(nil, href: second_url)
      end

      it "doesn't render destroy lineup links" do
        render

        assert_select "a[data-method='delete'][href=?]",
                      team_lineup_path(team, first_lineup), count: 0
        assert_select "a[data-method='delete'][href=?]",
                      team_lineup_path(team, second_lineup), count: 0
      end

      it "doesn't render new lineup link" do
        render

        expect(rendered).not_to have_link(nil, href: new_team_lineup_path(team))
      end
    end
  end
end
