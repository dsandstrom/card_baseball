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
  it { is_expected.to have_many(:contracts) }
  it { is_expected.to have_many(:players) }
  it { is_expected.to have_many(:lineups) }

  describe "#hitters" do
    let(:team) { Fabricate(:team, league: league) }
    let(:first_base) do
      Fabricate(:player, defense3: 1, defense7: -1, primary_position: 3,
                         offensive_rating: 80)
    end
    let(:outfield) do
      Fabricate(:player, defense7: -2, primary_position: 3,
                         offensive_rating: 90)
    end
    let(:pitcher) do
      Fabricate(:player, defense1: 1, bar1: 2, hitting_pitcher: false)
    end
    let(:hitting_pitcher) do
      Fabricate(:player, defense1: 2, defense3: 1, hitting_pitcher: true)
    end

    context "when no players" do
      it "returns []" do
        expect(team.hitters).to eq([])
      end
    end

    context "when a first baseman and pitcher" do
      before do
        Fabricate(:contract, team: team, player: first_base)
        Fabricate(:contract, team: team, player: pitcher)
      end

      it "returns []" do
        expect(team.hitters).to eq([first_base])
      end
    end

    context "when an outfielder" do
      before { Fabricate(:contract, team: team, player: outfield) }

      it "returns []" do
        expect(team.hitters).to eq([outfield])
      end
    end

    context "when a hitting_pitcher" do
      before { Fabricate(:contract, team: team, player: hitting_pitcher) }

      it "returns []" do
        expect(team.hitters).to eq([hitting_pitcher])
      end
    end

    context "when a first baseman and outfielder" do
      before do
        Fabricate(:contract, team: team, player: first_base)
        Fabricate(:contract, team: team, player: outfield)
      end

      it "returns []" do
        expect(team.hitters).to eq([outfield, first_base])
      end
    end
  end
end
