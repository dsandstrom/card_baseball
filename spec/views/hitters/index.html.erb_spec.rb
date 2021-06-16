# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitters/index", type: :view do
  let(:first_hitter) { Fabricate(:hitter) }
  let(:second_hitter) { Fabricate(:hitter) }
  let(:first_path) { hitter_path(first_hitter) }
  let(:second_path) { hitter_path(second_hitter) }

  before(:each) do
    assign(:hitters, [first_hitter, second_hitter])
  end

  it "renders a list of hitters" do
    render

    assert_select "#hitter_#{first_hitter.id}"
    expect(rendered).to have_link(nil, href: first_path)

    assert_select "#hitter_#{second_hitter.id}"
    expect(rendered).to have_link(nil, href: second_path)
  end

  it "renders new hitter link" do
    render

    expect(rendered).to have_link(nil, href: new_hitter_path)
  end
end
