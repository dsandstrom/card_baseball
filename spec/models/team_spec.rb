# frozen_string_literal: true

require "rails_helper"

RSpec.describe Team, type: :model do
  let(:league) { Fabricate(:league) }

  before do
    @team = Team.new(name: "Padres", league_id: league.id)
  end

  subject { @team }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:league_id) }
  it do
    is_expected.to validate_uniqueness_of(:name).case_insensitive
  end

  it { is_expected.to belong_to(:league) }
  it { is_expected.to have_many(:hitter_contracts) }
  it { is_expected.to have_many(:hitters) }
  it { is_expected.to have_many(:contracts) }
  it { is_expected.to have_many(:players) }
  it { is_expected.to have_many(:lineups) }
end
