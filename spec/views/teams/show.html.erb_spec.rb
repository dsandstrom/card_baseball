# frozen_string_literal: true

require "rails_helper"

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, Team.create!(
                            name: "Name",
                            icon: "Icon",
                            league_id: 2
                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Icon/)
    expect(rendered).to match(/2/)
  end
end
