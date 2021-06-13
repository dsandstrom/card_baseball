# frozen_string_literal: true

require "rails_helper"

RSpec.describe "hitters/show", type: :view do
  let(:hitter) { Fabricate(:hitter) }

  before(:each) do
    @hitter = assign(:hitter, hitter)
  end

  it "renders attributes in <p>" do
    render

    assert_select ".hitter-name", hitter.name
  end

  it "renders edit link" do
    render

    expect(rendered).to have_link(nil, href: edit_hitter_path(hitter))
  end
end
