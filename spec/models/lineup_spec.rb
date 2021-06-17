# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lineup, type: :model do
  let(:team) { Fabricate(:team) }

  before do
    @lineup = Lineup.new(name: "Main", team_id: team.id)
  end

  subject { @lineup }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:team_id) }

  it do
    is_expected.to validate_uniqueness_of(:name).scoped_to(:team_id)
                                                .case_insensitive
  end

  it do
    is_expected.to validate_inclusion_of(:vs).in_array([nil, "left", "right"])
  end

  it { is_expected.to belong_to(:team) }
end
