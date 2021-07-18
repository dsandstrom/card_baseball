# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/index", type: :view do
  let(:admin) { Fabricate(:admin) }
  let(:user) { Fabricate(:user) }
  let(:first_league) { Fabricate(:league) }
  let(:second_league) { Fabricate(:league) }
  let(:first_path) { league_path(first_league) }
  let(:second_path) { league_path(second_league) }

  before(:each) do
    assign(:leagues, [first_league, second_league])
  end

  def sort_path(league, direction)
    sort_league_path(league, league: { row_order_position: direction })
  end

  context "for an admin" do
    before { enable_can(view, admin) }

    it "renders a list of leagues" do
      render

      assert_select "#league_#{first_league.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#league_#{second_league.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end

    it "renders new league link" do
      render
      expect(rendered).to have_link(nil, href: new_league_path)
    end

    it "renders edit league links" do
      render

      expect(rendered).to have_link(nil, href: edit_league_path(first_league))
      expect(rendered).to have_link(nil, href: edit_league_path(second_league))
    end

    it "renders sort league links" do
      render

      expect(rendered).to have_link(nil, href: sort_path(first_league, "down"))
      expect(rendered).to have_link(nil, href: sort_path(second_league, "up"))

      expect(rendered)
        .not_to have_link(nil, href: sort_path(first_league, "up"))
      expect(rendered)
        .not_to have_link(nil, href: sort_path(second_league, "down"))
    end

    it "renders destroy league links" do
      render

      assert_select "a[href=?][data-method='delete']", first_path
      assert_select "a[href=?][data-method='delete']", second_path
    end
  end

  context "for a user" do
    before { enable_can(view, user) }

    it "renders a list of leagues" do
      render

      assert_select "#league_#{first_league.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#league_#{second_league.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end

    it "doesn't render new league link" do
      render
      expect(rendered).not_to have_link(nil, href: new_league_path)
    end

    it "doesn't render edit league links" do
      render

      expect(rendered)
        .not_to have_link(nil, href: edit_league_path(first_league))
      expect(rendered)
        .not_to have_link(nil, href: edit_league_path(second_league))
    end

    it "doesn't render sort league links" do
      render

      expect(rendered)
        .not_to have_link(nil, href: sort_path(first_league, "down"))
      expect(rendered)
        .not_to have_link(nil, href: sort_path(second_league, "up"))
    end

    it "doesn't render destroy league links" do
      render

      assert_select "a[href=?][data-method='delete']", first_path, count: 0
      assert_select "a[href=?][data-method='delete']", second_path, count: 0
    end
  end
end
