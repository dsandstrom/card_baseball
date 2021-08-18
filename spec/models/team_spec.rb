# frozen_string_literal: true

require "rails_helper"

RSpec.describe Team, type: :model do
  let(:league) { Fabricate(:league) }

  before do
    @team = Team.new(name: "Padres", identifier: "PAD", league_id: league.id)
  end

  subject { @team }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:identifier) }
  it { is_expected.to validate_presence_of(:league_id) }
  it do
    is_expected.to validate_uniqueness_of(:name).case_insensitive
  end
  it do
    is_expected.to validate_uniqueness_of(:identifier).case_insensitive
  end

  it { is_expected.to belong_to(:league) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:contracts) }
  it { is_expected.to have_many(:players) }
  it { is_expected.to have_many(:lineups) }
  it { is_expected.to have_many(:rosters) }

  # INSTANCE

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
      Fabricate(:player, defense1: 1, bar1: 2, primary_position: 1,
                         hitting_pitcher: false, pitcher_rating: 72)
    end
    let(:hitting_pitcher) do
      Fabricate(:player, defense1: 2, defense3: 1, primary_position: 1,
                         hitting_pitcher: true, pitcher_rating: 85)
    end

    context "when no players" do
      before { Fabricate(:contract, player: first_base) }

      it "returns []" do
        expect(team.hitters).to eq([])
      end
    end

    context "when a first baseman and pitcher" do
      before do
        Fabricate(:contract, team: team, player: first_base)
        Fabricate(:contract, team: team, player: pitcher)
      end

      it "returns them" do
        expect(team.hitters).to eq([first_base])
      end
    end

    context "when an outfielder" do
      before { Fabricate(:contract, team: team, player: outfield) }

      it "returns them" do
        expect(team.hitters).to eq([outfield])
      end
    end

    context "when a hitting_pitcher" do
      before { Fabricate(:contract, team: team, player: hitting_pitcher) }

      it "returns them" do
        expect(team.hitters).to eq([hitting_pitcher])
      end
    end

    context "when a first baseman and outfielder" do
      before do
        Fabricate(:contract, team: team, player: first_base)
        Fabricate(:contract, team: team, player: outfield)
      end

      it "orders by offensive_rating" do
        expect(team.hitters).to eq([outfield, first_base])
      end
    end
  end

  describe "#pitchers" do
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
      Fabricate(:player, defense1: 1, bar1: 2, primary_position: 1,
                         hitting_pitcher: false, pitcher_rating: 72)
    end
    let(:hitting_pitcher) do
      Fabricate(:player, defense1: 2, defense3: 1, primary_position: 1,
                         hitting_pitcher: true, pitcher_rating: 85)
    end

    context "when no players" do
      before { Fabricate(:contract, player: first_base) }

      it "returns []" do
        expect(team.pitchers).to eq([])
      end
    end

    context "when a first baseman, outfielder, and pitcher" do
      before do
        Fabricate(:contract, team: team, player: first_base)
        Fabricate(:contract, team: team, player: outfield)
        Fabricate(:contract, team: team, player: pitcher)
      end

      it "returns pitcher" do
        expect(team.pitchers).to eq([pitcher])
      end
    end

    context "when a hitting_pitcher" do
      before { Fabricate(:contract, team: team, player: hitting_pitcher) }

      it "returns them" do
        expect(team.pitchers).to eq([hitting_pitcher])
      end
    end

    context "when two pitchers" do
      before do
        Fabricate(:contract, team: team, player: pitcher)
        Fabricate(:contract, team: team, player: hitting_pitcher)
      end

      it "orders by pitcher_rating" do
        expect(team.pitchers).to eq([hitting_pitcher, pitcher])
      end
    end
  end

  describe "#auto_roster!" do
    let(:team) { Fabricate(:team) }

    context "when no players" do
      before do
        Fabricate(:contract)
        Fabricate(:roster)
      end

      it "doesn't create any rosters" do
        expect do
          team.auto_roster!
        end.not_to change(Roster, :count)
      end
    end

    context "when starting pitcher" do
      let(:starting_pitcher) { Fabricate(:starting_pitcher) }

      before do
        Fabricate(:contract, team: team, player: starting_pitcher)
        Fabricate(:contract)
      end

      context "without roster" do
        it "creates one" do
          expect do
            team.auto_roster!
          end.to change(team.rosters.where(level: 4), :count).by(1)
        end
      end

      context "with roster" do
        before do
          Fabricate(:roster, team: team, player: starting_pitcher, position: 1)
        end

        it "doesn't create any rosters" do
          expect do
            team.auto_roster!
          end.not_to change(Roster, :count)
        end
      end
    end

    context "when relief pitcher" do
      let(:relief_pitcher) { Fabricate(:relief_pitcher) }

      before do
        Fabricate(:contract, team: team, player: relief_pitcher)
        Fabricate(:contract)
      end

      context "without roster" do
        it "creates one" do
          expect do
            team.auto_roster!
          end.to change(team.rosters.where(level: 4), :count).by(1)
        end
      end

      context "with roster" do
        before do
          Fabricate(:roster, team: team, player: relief_pitcher, position: 10)
        end

        it "doesn't create any rosters" do
          expect do
            team.auto_roster!
          end.not_to change(Roster, :count)
        end
      end
    end

    context "when infielder" do
      let(:infielder) { Fabricate(:player, primary_position: 5) }

      before do
        Fabricate(:contract, team: team, player: infielder)
        Fabricate(:contract)
      end

      context "without roster" do
        it "creates one" do
          expect do
            team.auto_roster!
          end.to change(team.rosters.where(level: 4), :count).by(1)
        end
      end

      context "with roster" do
        before do
          Fabricate(:roster, team: team, player: infielder, level: 3,
                             position: 3)
        end

        it "doesn't create any rosters" do
          expect do
            team.auto_roster!
          end.not_to change(Roster, :count)
        end
      end
    end

    context "when 7 starting pitchers" do
      before do
        7.times do |n|
          pitcher = Fabricate(:starting_pitcher, pitcher_rating: 70 + n)
          Fabricate(:contract, team: team, player: pitcher)
        end
      end

      it "creates 7 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters, :count).by(7)
      end

      it "creates 5 level 4 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 4).where(position: 1), :count)
          .by(5)
      end

      it "creates 1 level 3 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 3), :count).by(1)
      end

      it "creates 1 level 2 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 2), :count).by(1)
      end
    end

    context "when 9 starting pitchers" do
      before do
        9.times do |n|
          pitcher = Fabricate(:starting_pitcher, pitcher_rating: 70 + n)
          Fabricate(:contract, team: team, player: pitcher)
        end
      end

      it "creates 9 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters, :count).by(9)
      end

      it "creates 5 level 4 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 4), :count).by(5)
      end

      it "creates 2 level 3 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 3), :count).by(2)
      end

      it "creates 1 level 2 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 2), :count).by(1)
      end

      it "creates 1 level 1 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 1), :count).by(1)
      end
    end

    context "when 7 relief pitchers" do
      before do
        7.times do |n|
          pitcher = Fabricate(:relief_pitcher, pitcher_rating: 70 + n)
          Fabricate(:contract, team: team, player: pitcher)
        end
      end

      it "creates 7 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters, :count).by(7)
      end

      it "creates 5 level 4 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 4), :count).by(6)
      end

      it "creates 1 level 3 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 3), :count).by(1)
      end
    end

    context "when 9 relief pitchers" do
      before do
        9.times do |n|
          pitcher = Fabricate(:relief_pitcher, pitcher_rating: 70 + n)
          Fabricate(:contract, team: team, player: pitcher)
        end
      end

      it "creates 9 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters, :count).by(9)
      end

      it "creates 5 level 4 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 4).where(position: 10), :count)
          .by(6)
      end

      it "creates 1 level 3 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 3), :count).by(1)
      end

      it "creates 1 level 2 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 2), :count).by(1)
      end

      it "creates 1 level 1 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 1), :count).by(1)
      end
    end

    context "when 5 catchers" do
      before do
        5.times do |n|
          player = Fabricate(:player, primary_position: 2,
                                      offensive_rating: 70 + n)
          Fabricate(:contract, team: team, player: player)
        end
      end

      it "creates 5 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters, :count).by(5)
      end

      it "creates 4 level 4 rosters" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 4).where(position: 2), :count)
          .by(4)
      end

      it "creates 1 level 3 roster" do
        expect do
          team.auto_roster!
        end.to change(team.rosters.where(level: 3), :count).by(1)
      end
    end
  end
end
