# frozen_string_literal: true

require "rails_helper"

RSpec.describe "static/sitemap", type: :view do
  let(:user) { Fabricate(:user) }
  let(:league) { Fabricate(:league) }

  before do
    Fabricate(:team, league:)
    enable_can(view, user)
    assign(:leagues, [league])
  end

  it "renders page" do
    render template: subject, layout: "layouts/application"

    assert_select "h1", "Sitemap"
  end
end
