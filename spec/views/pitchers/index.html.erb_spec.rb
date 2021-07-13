# frozen_string_literal: true

require "rails_helper"

RSpec.describe "pitchers/index", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league: league) }
  let(:first_pitcher) { Fabricate(:pitcher) }
  let(:second_pitcher) { Fabricate(:pitcher) }
  let(:first_path) { player_path(first_pitcher) }
  let(:second_path) { player_path(second_pitcher) }

  context "when team" do
    before(:each) do
      assign(:team, team)
      assign(:league, league)
      assign(:pitchers, page([first_pitcher, second_pitcher]))
    end

    it "renders a list of pitchers" do
      render

      assert_select "#pitcher_#{first_pitcher.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#pitcher_#{second_pitcher.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end
  end

  context "when no team" do
    before(:each) do
      assign(:pitchers, page([first_pitcher, second_pitcher]))
    end

    it "renders a list of pitchers" do
      render

      assert_select "#pitcher_#{first_pitcher.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#pitcher_#{second_pitcher.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end
  end
end
