# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lineups/show", type: :view do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }

  before(:each) do
    assign(:team, team)
    assign(:league, team.league)
    @lineup = assign(:lineup, lineup)
    assign(:spots, lineup.spots)
  end

  it "renders lineup's name" do
    render

    assert_select ".lineup-name", lineup.full_name
  end
end
