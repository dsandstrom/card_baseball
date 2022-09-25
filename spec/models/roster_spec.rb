# frozen_string_literal: true

require "rails_helper"

# each team has 4 rosters, players have roster spot/level

RSpec.describe Roster, type: :model do
  let(:team) { Fabricate(:team) }
  let(:player) { Fabricate(:player, primary_position: 3, defense3: 1) }

  before do
    Fabricate(:contract, team:, player:)
    @roster = Roster.new(team_id: team.id, player_id: player.id, level: 1,
                         position: 3)
  end

  subject { @roster }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of :team_id }
  it { is_expected.to validate_presence_of :player_id }
  it { is_expected.to validate_presence_of :level }
  it { is_expected.to validate_presence_of :position }

  it { is_expected.to validate_inclusion_of(:level).in_array([1, 2, 3, 4]) }
  it { is_expected.to validate_uniqueness_of(:player_id) }

  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:player) }

  describe "validates" do
    describe "#player_on_team" do
      context "when no contract" do
        let(:new_team) { Fabricate(:team) }

        before do
          subject.team = new_team
        end

        it { is_expected.not_to be_valid }
      end
    end

    describe "#player_plays_position" do
      context "when level is 1" do
        before { subject.level = 1 }

        context "for a starting pitcher" do
          let(:player) { Fabricate(:starting_pitcher, relief_pitching: nil) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a relief pitcher" do
          let(:player) { Fabricate(:relief_pitcher, starting_pitching: nil) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a dual-threat pitcher" do
          let(:player) { Fabricate(:starting_pitcher, relief_pitching: 55) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a hitting pitcher" do
          let(:player) { Fabricate(:hitting_pitcher, defense7: 4) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).to be_valid
            end
          end
        end

        context "for a first baseman" do
          let(:player) { Fabricate(:player, primary_position: 3) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a shortstop" do
          let(:player) { Fabricate(:player, primary_position: 6) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for an outfielder" do
          let(:player) { Fabricate(:player, primary_position: 7) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for an center fielder" do
          let(:player) { Fabricate(:player, primary_position: 8) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a catcher" do
          let(:player) { Fabricate(:player, primary_position: 2) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should be valid" do
              expect(subject).to_not be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end
      end

      context "when level is 4" do
        before { subject.level = 4 }

        context "for a starting pitcher" do
          let(:player) { Fabricate(:starting_pitcher, relief_pitching: nil) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a relief pitcher" do
          let(:player) { Fabricate(:relief_pitcher, starting_pitching: nil) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a dual-threat pitcher" do
          let(:player) { Fabricate(:starting_pitcher, relief_pitching: 55) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a hitting pitcher" do
          let(:player) do
            Fabricate(:hitting_pitcher, defense7: nil, defense8: 4)
          end

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 8" do
            before { subject.position = 8 }

            it "should not be valid" do
              expect(subject).to be_valid
            end
          end
        end

        context "for a first baseman" do
          let(:player) { Fabricate(:player, primary_position: 3) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 4" do
            before { subject.position = 4 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for a shortstop" do
          let(:player) { Fabricate(:player, primary_position: 6) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 6" do
            before { subject.position = 6 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for an outfielder" do
          let(:player) { Fabricate(:player, primary_position: 7) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 8" do
            before { subject.position = 8 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end

        context "for an center fielder" do
          let(:player) { Fabricate(:player, primary_position: 8) }

          before do
            Fabricate(:contract, team:, player:)
            subject.player = player
          end

          context "when position is 8" do
            before { subject.position = 8 }

            it "should be valid" do
              expect(subject).to be_valid
            end
          end

          context "when position is 1" do
            before { subject.position = 1 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 7" do
            before { subject.position = 7 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 3" do
            before { subject.position = 3 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end

          context "when position is 10" do
            before { subject.position = 10 }

            it "should not be valid" do
              expect(subject).not_to be_valid
            end
          end
        end
      end
    end

    describe "#players_at_level4" do
      context "for a new roster" do
        let(:roster) do
          Fabricate.build(:roster, team:, player:, level: 4,
                                   position: 3)
        end

        context "when already 25 at level 4" do
          before { 25.times { Fabricate(:roster, team:, level: 4) } }

          it "should be valid" do
            expect(roster).to be_valid
          end
        end

        context "when already 26 at level 4" do
          before { 26.times { Fabricate(:roster, team:, level: 4) } }

          context "and level is 4" do
            before { roster.level = 4 }

            it "should not be valid" do
              expect(roster).not_to be_valid
            end
          end

          context "and level is 3" do
            before { roster.level = 3 }

            it "should be valid" do
              expect(roster).to be_valid
            end
          end
        end
      end

      context "for a persisted level 4 roster" do
        let!(:roster) do
          Fabricate(:roster, team:, player:, level: 4, position: 3)
        end

        context "when already 25 at level 4" do
          before { 25.times { Fabricate(:roster, team:, level: 4) } }

          it "should be valid" do
            expect(roster).to be_valid
          end
        end
      end

      context "for a persisted level 3 roster" do
        let(:roster) do
          Fabricate(:roster, team:, player:, level: 3, position: 3)
        end

        context "when already 25 at level 4" do
          before do
            25.times { Fabricate(:roster, team:, level: 4) }
            roster
          end

          it "should be valid" do
            expect(roster).to be_valid
          end
        end

        context "when already 26 at level 4 and moving to 4" do
          before do
            26.times { Fabricate(:roster, team:, level: 4) }
            roster.level = 4
          end

          it "should not be valid" do
            expect(roster).not_to be_valid
          end
        end
      end
    end
  end

  # CLASS

  describe ".level_positions" do
    context "when level is 1" do
      it "returns a subset" do
        expect(Roster.level_positions(1)).to eq([1, 10, 3, 7])
      end
    end

    context "when level is 2" do
      it "returns a subset" do
        expect(Roster.level_positions(2)).to eq([1, 10, 3, 7])
      end
    end

    context "when level is 3" do
      it "returns a subset" do
        expect(Roster.level_positions(3)).to eq([1, 10, 3, 7])
      end
    end

    context "when level is 4" do
      it "returns a subset" do
        expect(Roster.level_positions(4)).to eq([2, 3, 4, 5, 6, 7, 8, 1, 10])
      end
    end
  end

  describe ".position_initials" do
    context "when level is 1" do
      context "when position is 1" do
        it "returns 'SP'" do
          expect(Roster.position_initials(1, 1)).to eq("SP")
        end
      end

      context "when position is 2" do
        it "returns nil" do
          expect(Roster.position_initials(2, 1)).to eq(nil)
        end
      end

      context "when position is 3" do
        it "returns 'IF'" do
          expect(Roster.position_initials(3, 1)).to eq("IF")
        end
      end

      context "when position is 4" do
        it "returns nil" do
          expect(Roster.position_initials(4, 1)).to be_nil
        end
      end

      context "when position is 5" do
        it "returns nil" do
          expect(Roster.position_initials(5, 1)).to be_nil
        end
      end

      context "when position is 6" do
        it "returns nil" do
          expect(Roster.position_initials(6, 1)).to be_nil
        end
      end

      context "when position is 7" do
        it "returns 'OF'" do
          expect(Roster.position_initials(7, 1)).to eq("OF")
        end
      end

      context "when position is 8" do
        it "returns nil" do
          expect(Roster.position_initials(8, 1)).to be_nil
        end
      end
    end

    context "when level is 3" do
      context "when position is 1" do
        it "returns 'SP'" do
          expect(Roster.position_initials(1, 3)).to eq("SP")
        end
      end

      context "when position is 2" do
        it "returns nil" do
          expect(Roster.position_initials(2, 3)).to eq(nil)
        end
      end

      context "when position is 3" do
        it "returns 'IF'" do
          expect(Roster.position_initials(3, 3)).to eq("IF")
        end
      end

      context "when position is 4" do
        it "returns nil" do
          expect(Roster.position_initials(4, 3)).to be_nil
        end
      end

      context "when position is 5" do
        it "returns nil" do
          expect(Roster.position_initials(5, 3)).to be_nil
        end
      end

      context "when position is 6" do
        it "returns nil" do
          expect(Roster.position_initials(6, 3)).to be_nil
        end
      end

      context "when position is 7" do
        it "returns 'OF'" do
          expect(Roster.position_initials(7, 3)).to eq("OF")
        end
      end

      context "when position is 8" do
        it "returns nil" do
          expect(Roster.position_initials(8, 3)).to be_nil
        end
      end
    end

    context "when level is 4" do
      context "when position is 1" do
        it "returns 'SP'" do
          expect(Roster.position_initials(1, 4)).to eq("SP")
        end
      end

      context "when position is 2" do
        it "returns 'C'" do
          expect(Roster.position_initials(2, 4)).to eq("C")
        end
      end

      context "when position is 3" do
        it "returns '1B'" do
          expect(Roster.position_initials(3, 4)).to eq("1B")
        end
      end

      context "when position is 4" do
        it "returns '2B" do
          expect(Roster.position_initials(4, 4)).to eq("2B")
        end
      end

      context "when position is 5" do
        it "returns '3B" do
          expect(Roster.position_initials(5, 4)).to eq("3B")
        end
      end

      context "when position is 6" do
        it "returns 'SS" do
          expect(Roster.position_initials(6, 4)).to eq("SS")
        end
      end

      context "when position is 7" do
        it "returns 'OF" do
          expect(Roster.position_initials(7, 4)).to eq("OF")
        end
      end

      context "when position is 8" do
        it "returns 'CF" do
          expect(Roster.position_initials(8, 4)).to eq("CF")
        end
      end

      context "when position is 9" do
        it "returns 'DH'" do
          expect(Roster.position_initials(9, 4)).to eq("DH")
        end
      end

      context "when position is 10" do
        it "returns 'RP'" do
          expect(Roster.position_initials(10, 4)).to eq("RP")
        end
      end
    end
  end

  describe ".position_name" do
    context "when level is 1" do
      context "when position is 1" do
        it "returns 'Starting Pitcher'" do
          expect(Roster.position_name(1, 1)).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        it "returns nil" do
          expect(Roster.position_name(2, 1)).to eq(nil)
        end
      end

      context "when position is 3" do
        it "returns 'Infielder'" do
          expect(Roster.position_name(3, 1)).to eq("Infielder")
        end
      end

      context "when position is 4" do
        it "returns nil" do
          expect(Roster.position_name(4, 1)).to be_nil
        end
      end

      context "when position is 5" do
        it "returns nil" do
          expect(Roster.position_name(5, 1)).to be_nil
        end
      end

      context "when position is 6" do
        it "returns nil" do
          expect(Roster.position_name(6, 1)).to be_nil
        end
      end

      context "when position is 7" do
        it "returns 'Outfielder'" do
          expect(Roster.position_name(7, 1)).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        it "returns nil" do
          expect(Roster.position_name(8, 1)).to be_nil
        end
      end
    end

    context "when level is 3" do
      context "when position is 1" do
        it "returns 'Starting Pitcher'" do
          expect(Roster.position_name(1, 3)).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        it "returns nil" do
          expect(Roster.position_name(2, 3)).to eq(nil)
        end
      end

      context "when position is 3" do
        it "returns 'Infielder'" do
          expect(Roster.position_name(3, 3)).to eq("Infielder")
        end
      end

      context "when position is 4" do
        it "returns nil" do
          expect(Roster.position_name(4, 3)).to be_nil
        end
      end

      context "when position is 5" do
        it "returns nil" do
          expect(Roster.position_name(5, 3)).to be_nil
        end
      end

      context "when position is 6" do
        it "returns nil" do
          expect(Roster.position_name(6, 3)).to be_nil
        end
      end

      context "when position is 7" do
        it "returns 'Outfielder'" do
          expect(Roster.position_name(7, 3)).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        it "returns nil" do
          expect(Roster.position_name(8, 3)).to be_nil
        end
      end
    end

    context "when level is 4" do
      context "when position is 1" do
        it "returns 'Starting Pitcher'" do
          expect(Roster.position_name(1, 4)).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        it "returns 'Catcher'" do
          expect(Roster.position_name(2, 4)).to eq("Catcher")
        end
      end

      context "when position is 3" do
        it "returns 'First Baseman'" do
          expect(Roster.position_name(3, 4)).to eq("First Baseman")
        end
      end

      context "when position is 4" do
        it "returns 'Second Baseman" do
          expect(Roster.position_name(4, 4)).to eq("Second Baseman")
        end
      end

      context "when position is 5" do
        it "returns 'Third Baseman" do
          expect(Roster.position_name(5, 4)).to eq("Third Baseman")
        end
      end

      context "when position is 6" do
        it "returns 'Shortstop" do
          expect(Roster.position_name(6, 4)).to eq("Shortstop")
        end
      end

      context "when position is 7" do
        it "returns 'Outfielder" do
          expect(Roster.position_name(7, 4)).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        it "returns 'Center Fielder" do
          expect(Roster.position_name(8, 4)).to eq("Center Fielder")
        end
      end

      context "when position is 9" do
        it "returns 'Designated Hitter'" do
          expect(Roster.position_name(9, 4)).to eq("Designated Hitter")
        end
      end

      context "when position is 10" do
        it "returns 'Relief Pitcher'" do
          expect(Roster.position_name(10, 4)).to eq("Relief Pitcher")
        end
      end
    end
  end

  describe ".position_from_initials" do
    context "when given 4 for level" do
      context "and 'SP' for initials" do
        it "returns 1" do
          expect(described_class.position_from_initials("SP", 4)).to eq(1)
        end
      end

      context "and 'C' for initials" do
        it "returns 2" do
          expect(described_class.position_from_initials("C", 4)).to eq(2)
        end
      end

      context "and '1B' for initials" do
        it "returns 3" do
          expect(described_class.position_from_initials("1B", 4)).to eq(3)
        end
      end

      context "and '2B' for initials" do
        it "returns 4" do
          expect(described_class.position_from_initials("2B", 4)).to eq(4)
        end
      end

      context "and '3B' for initials" do
        it "returns 5" do
          expect(described_class.position_from_initials("3B", 4)).to eq(5)
        end
      end

      context "and 'SS' for initials" do
        it "returns 6" do
          expect(described_class.position_from_initials("SS", 4)).to eq(6)
        end
      end

      context "and 'OF' for initials" do
        it "returns 7" do
          expect(described_class.position_from_initials("OF", 4)).to eq(7)
        end
      end

      context "and 'CF' for initials" do
        it "returns 8" do
          expect(described_class.position_from_initials("CF", 4)).to eq(8)
        end
      end

      context "and 'RP' for initials" do
        it "returns 10" do
          expect(described_class.position_from_initials("RP", 4)).to eq(10)
        end
      end
    end

    [1, 2, 3].each do |level|
      context "when given #{level} for level" do
        context "and 'SP' for initials" do
          it "returns 1" do
            expect(described_class.position_from_initials("SP", level)).to eq(1)
          end
        end

        context "and 'IF' for initials" do
          it "returns 3" do
            expect(described_class.position_from_initials("IF", level)).to eq(3)
          end
        end

        context "and 'OF' for initials" do
          it "returns 7" do
            expect(described_class.position_from_initials("OF", level)).to eq(7)
          end
        end

        context "and 'RP' for initials" do
          it "returns 10" do
            expect(described_class.position_from_initials("RP", level))
              .to eq(10)
          end
        end
      end
    end
  end

  describe ".imported_attrs" do
    context "when given 'SP1'" do
      it "returns level 4, position 1, row_order_position 0" do
        expect(described_class.imported_attrs("SP1"))
          .to eq(level: 4, position: 1, row_order_position: 0)
      end
    end

    context "when given 'SP2'" do
      it "returns level 4, position 1, row_order_position 1" do
        expect(described_class.imported_attrs("SP2"))
          .to eq(level: 4, position: 1, row_order_position: 1)
      end
    end

    context "when given 'SP5'" do
      it "returns level 4, position 1, row_order_position 4" do
        expect(described_class.imported_attrs("SP5"))
          .to eq(level: 4, position: 1, row_order_position: 4)
      end
    end

    context "when given 'C1'" do
      it "returns level 4, position 2, row_order_position 0" do
        expect(described_class.imported_attrs("C1"))
          .to eq(level: 4, position: 2, row_order_position: 0)
      end
    end

    context "when given 'C2'" do
      it "returns level 4, position 2, row_order_position 1" do
        expect(described_class.imported_attrs("C2"))
          .to eq(level: 4, position: 2, row_order_position: 1)
      end
    end

    context "when given '1B1'" do
      it "returns level 4, position 3, row_order_position 0" do
        expect(described_class.imported_attrs("1B1"))
          .to eq(level: 4, position: 3, row_order_position: 0)
      end
    end

    context "when given '1B2'" do
      it "returns level 4, position 3, row_order_position 1" do
        expect(described_class.imported_attrs("1B2"))
          .to eq(level: 4, position: 3, row_order_position: 1)
      end
    end

    context "when given '2B1'" do
      it "returns level 4, position 4, row_order_position 0" do
        expect(described_class.imported_attrs("2B1"))
          .to eq(level: 4, position: 4, row_order_position: 0)
      end
    end

    context "when given '2B2'" do
      it "returns level 4, position 1, row_order_position 1" do
        expect(described_class.imported_attrs("2B2"))
          .to eq(level: 4, position: 4, row_order_position: 1)
      end
    end

    context "when given '3B1'" do
      it "returns level 4, position 5, row_order_position 0" do
        expect(described_class.imported_attrs("3B1"))
          .to eq(level: 4, position: 5, row_order_position: 0)
      end
    end

    context "when given '3B2'" do
      it "returns level 4, position 5, row_order_position 1" do
        expect(described_class.imported_attrs("3B2"))
          .to eq(level: 4, position: 5, row_order_position: 1)
      end
    end

    context "when given 'SS1'" do
      it "returns level 4, position 6, row_order_position 0" do
        expect(described_class.imported_attrs("SS1"))
          .to eq(level: 4, position: 6, row_order_position: 0)
      end
    end

    context "when given 'SS2'" do
      it "returns level 4, position 6, row_order_position 1" do
        expect(described_class.imported_attrs("SS2"))
          .to eq(level: 4, position: 6, row_order_position: 1)
      end
    end

    context "when given 'OF1'" do
      it "returns level 4, position 7, row_order_position 0" do
        expect(described_class.imported_attrs("OF1"))
          .to eq(level: 4, position: 7, row_order_position: 0)
      end
    end

    context "when given 'OF2'" do
      it "returns level 4, position 7, row_order_position 1" do
        expect(described_class.imported_attrs("OF2"))
          .to eq(level: 4, position: 7, row_order_position: 1)
      end
    end

    context "when given 'CF1'" do
      it "returns level 4, position 8, row_order_position 0" do
        expect(described_class.imported_attrs("CF1"))
          .to eq(level: 4, position: 8, row_order_position: 0)
      end
    end

    context "when given 'CF2'" do
      it "returns level 4, position 8, row_order_position 1" do
        expect(described_class.imported_attrs("CF2"))
          .to eq(level: 4, position: 8, row_order_position: 1)
      end
    end

    context "when given 'RP1'" do
      it "returns level 4, position 1, row_order_position 0" do
        expect(described_class.imported_attrs("RP1"))
          .to eq(level: 4, position: 10, row_order_position: 0)
      end
    end

    context "when given 'RP2'" do
      it "returns level 4, position 1, row_order_position 1" do
        expect(described_class.imported_attrs("RP2"))
          .to eq(level: 4, position: 10, row_order_position: 1)
      end
    end

    context "when given '2ASP1'" do
      it "returns level 2, position 1, row_order_position 0" do
        expect(described_class.imported_attrs("2ASP1"))
          .to eq(level: 2, position: 1, row_order_position: 0)
      end
    end

    context "when given '2ASP2'" do
      it "returns level 2, position 1, row_order_position 1" do
        expect(described_class.imported_attrs("2ASP2"))
          .to eq(level: 2, position: 1, row_order_position: 1)
      end
    end

    context "when given '2AIF1'" do
      it "returns level 2, position 3, row_order_position 0" do
        expect(described_class.imported_attrs("2AIF1"))
          .to eq(level: 2, position: 3, row_order_position: 0)
      end
    end

    context "when given '2AIF2'" do
      it "returns level 2, position 3, row_order_position 1" do
        expect(described_class.imported_attrs("2AIF2"))
          .to eq(level: 2, position: 3, row_order_position: 1)
      end
    end

    context "when given '2AOF1'" do
      it "returns level 2, position 7, row_order_position 0" do
        expect(described_class.imported_attrs("2AOF1"))
          .to eq(level: 2, position: 7, row_order_position: 0)
      end
    end

    context "when given '2AOF2'" do
      it "returns level 2, position 7, row_order_position 1" do
        expect(described_class.imported_attrs("2AOF2"))
          .to eq(level: 2, position: 7, row_order_position: 1)
      end
    end

    context "when given '2ARP1'" do
      it "returns level 2, position 10, row_order_position 0" do
        expect(described_class.imported_attrs("2ARP1"))
          .to eq(level: 2, position: 10, row_order_position: 0)
      end
    end

    context "when given '2ARP2'" do
      it "returns level 2, position 10, row_order_position 1" do
        expect(described_class.imported_attrs("2ARP2"))
          .to eq(level: 2, position: 10, row_order_position: 1)
      end
    end

    context "when given '3ASP1'" do
      it "returns level 3, position 1, row_order_position 0" do
        expect(described_class.imported_attrs("3ASP1"))
          .to eq(level: 3, position: 1, row_order_position: 0)
      end
    end

    context "when given '3ASP2'" do
      it "returns level 3, position 1, row_order_position 1" do
        expect(described_class.imported_attrs("3ASP2"))
          .to eq(level: 3, position: 1, row_order_position: 1)
      end
    end

    context "when given '3AIF1'" do
      it "returns level 3, position 3, row_order_position 0" do
        expect(described_class.imported_attrs("3AIF1"))
          .to eq(level: 3, position: 3, row_order_position: 0)
      end
    end

    context "when given '3AIF2'" do
      it "returns level 3, position 3, row_order_position 1" do
        expect(described_class.imported_attrs("3AIF2"))
          .to eq(level: 3, position: 3, row_order_position: 1)
      end
    end

    context "when given '3AOF1'" do
      it "returns level 3, position 7, row_order_position 0" do
        expect(described_class.imported_attrs("3AOF1"))
          .to eq(level: 3, position: 7, row_order_position: 0)
      end
    end

    context "when given '3AOF2'" do
      it "returns level 3, position 7, row_order_position 1" do
        expect(described_class.imported_attrs("3AOF2"))
          .to eq(level: 3, position: 7, row_order_position: 1)
      end
    end

    context "when given '3ARP1'" do
      it "returns level 3, position 10, row_order_position 0" do
        expect(described_class.imported_attrs("3ARP1"))
          .to eq(level: 3, position: 10, row_order_position: 0)
      end
    end

    context "when given '3ARP2'" do
      it "returns level 3, position 10, row_order_position 1" do
        expect(described_class.imported_attrs("3ARP2"))
          .to eq(level: 3, position: 10, row_order_position: 1)
      end
    end

    context "when given '1A1'" do
      it "returns level 1, position nil, row_order_position 0" do
        expect(described_class.imported_attrs("1A1"))
          .to eq(level: 1, row_order_position: 0)
      end
    end

    context "when given '1A2'" do
      it "returns level 1, position nil, row_order_position 1" do
        expect(described_class.imported_attrs("1A2"))
          .to eq(level: 1, row_order_position: 1)
      end
    end

    context "when given '1A6'" do
      it "returns level 1, position nil, row_order_position 5" do
        expect(described_class.imported_attrs("1A6"))
          .to eq(level: 1, row_order_position: 5)
      end
    end

    context "when given 'X'" do
      it "returns nil" do
        expect(described_class.imported_attrs("X")).to be_nil
      end
    end

    context "when given '1AX'" do
      it "returns nil" do
        expect(described_class.imported_attrs("1AX")).to be_nil
      end
    end
  end

  # INSTANCE

  describe "#position_initials" do
    context "when level is 1" do
      before { subject.level = 1 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'SP'" do
          expect(subject.position_initials).to eq("SP")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns nil" do
          expect(subject.position_initials).to eq(nil)
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'IF'" do
          expect(subject.position_initials).to eq("IF")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'OF'" do
          expect(subject.position_initials).to eq("OF")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end
    end

    context "when level is 3" do
      before { subject.level = 3 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'SP'" do
          expect(subject.position_initials).to eq("SP")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns nil" do
          expect(subject.position_initials).to eq(nil)
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'IF'" do
          expect(subject.position_initials).to eq("IF")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'OF'" do
          expect(subject.position_initials).to eq("OF")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns nil" do
          expect(subject.position_initials).to be_nil
        end
      end
    end

    context "when level is 4" do
      before { subject.level = 4 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'SP'" do
          expect(subject.position_initials).to eq("SP")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns nil" do
          expect(subject.position_initials).to eq("C")
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'IF'" do
          expect(subject.position_initials).to eq("1B")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns '2B" do
          expect(subject.position_initials).to eq("2B")
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns '3B" do
          expect(subject.position_initials).to eq("3B")
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns 'SS" do
          expect(subject.position_initials).to eq("SS")
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'OF" do
          expect(subject.position_initials).to eq("OF")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns 'CF" do
          expect(subject.position_initials).to eq("CF")
        end
      end

      context "when position is 9" do
        before { subject.position = 9 }

        it "returns 'DH'" do
          expect(subject.position_initials).to eq("DH")
        end
      end

      context "when position is 10" do
        before { subject.position = 10 }

        it "returns 'RP'" do
          expect(subject.position_initials).to eq("RP")
        end
      end
    end
  end

  describe "#position_name" do
    context "when level is 1" do
      before { subject.level = 1 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'Starting Pitcher'" do
          expect(subject.position_name).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns nil" do
          expect(subject.position_name).to eq(nil)
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'Infielder'" do
          expect(subject.position_name).to eq("Infielder")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'Outfielder'" do
          expect(subject.position_name).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end
    end

    context "when level is 3" do
      before { subject.level = 3 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'Starting Pitcher'" do
          expect(subject.position_name).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns nil" do
          expect(subject.position_name).to eq(nil)
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'Infielder'" do
          expect(subject.position_name).to eq("Infielder")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'Outfielder'" do
          expect(subject.position_name).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns nil" do
          expect(subject.position_name).to be_nil
        end
      end
    end

    context "when level is 4" do
      before { subject.level = 4 }

      context "when position is 1" do
        before { subject.position = 1 }

        it "returns 'Starting Pitcher'" do
          expect(subject.position_name).to eq("Starting Pitcher")
        end
      end

      context "when position is 2" do
        before { subject.position = 2 }

        it "returns 'Catcher'" do
          expect(subject.position_name).to eq("Catcher")
        end
      end

      context "when position is 3" do
        before { subject.position = 3 }

        it "returns 'First Baseman'" do
          expect(subject.position_name).to eq("First Baseman")
        end
      end

      context "when position is 4" do
        before { subject.position = 4 }

        it "returns 'Second Baseman" do
          expect(subject.position_name).to eq("Second Baseman")
        end
      end

      context "when position is 5" do
        before { subject.position = 5 }

        it "returns 'Third Baseman" do
          expect(subject.position_name).to eq("Third Baseman")
        end
      end

      context "when position is 6" do
        before { subject.position = 6 }

        it "returns 'Shortstop" do
          expect(subject.position_name).to eq("Shortstop")
        end
      end

      context "when position is 7" do
        before { subject.position = 7 }

        it "returns 'Outfielder" do
          expect(subject.position_name).to eq("Outfielder")
        end
      end

      context "when position is 8" do
        before { subject.position = 8 }

        it "returns 'Center Fielder" do
          expect(subject.position_name).to eq("Center Fielder")
        end
      end

      context "when position is 9" do
        before { subject.position = 9 }

        it "returns 'Designated Hitter'" do
          expect(subject.position_name).to eq("Designated Hitter")
        end
      end

      context "when position is 10" do
        before { subject.position = 10 }

        it "returns 'Relief Pitcher'" do
          expect(subject.position_name).to eq("Relief Pitcher")
        end
      end
    end
  end
end
