# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitters/index", type: :view do
  let(:league) { Fabricate(:league) }
  let(:team) { Fabricate(:team, league:) }
  let(:first_hitter) { Fabricate(:hitter) }
  let(:second_hitter) { Fabricate(:hitter) }
  let(:first_path) { player_path(first_hitter) }
  let(:second_path) { player_path(second_hitter) }

  context "when team" do
    before(:each) do
      assign(:team, team)
      assign(:league, league)
      assign(:hitters, page([first_hitter, second_hitter]))
    end

    it "renders a list of hitters" do
      render

      assert_select "#hitter_#{first_hitter.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#hitter_#{second_hitter.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end
  end

  context "when no team" do
    before(:each) do
      assign(:hitters, page([first_hitter, second_hitter]))
    end

    it "renders a list of hitters" do
      render

      assert_select "#hitter_#{first_hitter.id}"
      expect(rendered).to have_link(nil, href: first_path)

      assert_select "#hitter_#{second_hitter.id}"
      expect(rendered).to have_link(nil, href: second_path)
    end
  end
end
