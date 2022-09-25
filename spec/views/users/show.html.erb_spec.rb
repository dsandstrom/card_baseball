# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/show", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:another_user) { Fabricate(:user) }
  let(:first_team) { Fabricate(:team, user:) }
  let(:second_team) { Fabricate(:team, user: another_user) }

  before(:each) do
    assign(:user, user)
    assign(:teams, [])
  end

  context "for an admin" do
    before { enable_can(view, admin) }

    it "renders user" do
      render

      assert_select ".user-name", user.name
      assert_select ".user-email", user.email
      assert_select ".user-location", user.location
    end

    it "renders edit link" do
      render

      expect(rendered).to have_link(nil, href: edit_user_path(user))
    end

    context "with no teams" do
      before { first_team }

      it "renders" do
        render

        assert_select ".teams", count: 0
      end
    end

    context "with one team" do
      before do
        first_team.update(user_id: user.id)
        assign(:teams, [first_team])
      end

      it "renders it" do
        render

        assert_select ".teams #team_#{first_team.id}"
      end
    end

    context "with two teams" do
      before do
        first_team.update(user_id: user.id)
        second_team.update(user_id: user.id)
        assign(:teams, [first_team, second_team])
      end

      it "renders it" do
        render

        assert_select ".teams #team_#{first_team.id}"
        assert_select ".teams #team_#{second_team.id}"
      end
    end
  end

  context "for the current user" do
    before do
      enable_can(view, user)
      assign(:user, user)
    end

    it "renders user" do
      render

      assert_select ".user-name", user.name
    end

    it "renders edit link" do
      render

      expect(rendered).to have_link(nil, href: edit_user_path(user))
    end

    context "with no teams" do
      before { second_team }

      it "renders" do
        render

        assert_select ".teams", count: 0
      end
    end

    context "with one team" do
      before do
        assign(:teams, [first_team])
      end

      it "renders it" do
        render

        assert_select ".teams #team_#{first_team.id}"
      end

      it "renders edit team link" do
        render

        url = edit_league_team_path(first_team.league, first_team)
        expect(rendered).to have_link(nil, href: url)
      end
    end
  end

  context "for another user" do
    before do
      enable_can(view, user)
      assign(:user, another_user)
    end

    it "renders user" do
      render

      assert_select ".user-name", another_user.name
    end

    it "doesn't render edit link" do
      render

      expect(rendered).not_to have_link(nil, href: edit_user_path(another_user))
    end

    context "with one team" do
      before do
        assign(:teams, [second_team])
      end

      it "renders it" do
        render

        assert_select ".teams #team_#{second_team.id}"
      end

      it "doesn't render edit team link" do
        render

        url = edit_league_team_path(second_team.league, second_team)
        expect(rendered).not_to have_link(nil, href: url)
      end
    end
  end
end
