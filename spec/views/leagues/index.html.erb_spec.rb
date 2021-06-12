# frozen_string_literal: true

require "rails_helper"

RSpec.describe "leagues/index", type: :view do
  let(:first_league) { Fabricate(:league) }
  let(:second_league) { Fabricate(:league) }
  let(:first_path) { league_path(first_league) }
  let(:second_path) { league_path(second_league) }

  before(:each) do
    assign(:leagues, [first_league, second_league])
  end

  it "renders a list of leagues" do
    render

    assert_select "#league_#{first_league.id}"
    expect(rendered).to have_link(nil, href: first_path)
    expect(rendered).to have_link(nil, href: edit_league_path(first_league))
    assert_select "a[href='#{first_path}'][data-method='delete']"

    assert_select "#league_#{second_league.id}"
    expect(rendered).to have_link(nil, href: second_path)
    expect(rendered).to have_link(nil, href: edit_league_path(second_league))
    assert_select "a[href='#{second_path}'][data-method='delete']"
  end

  it "renders new league link" do
    render
    expect(rendered).to have_link(nil, href: new_league_path)
  end
end
