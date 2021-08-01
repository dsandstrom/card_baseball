# frozen_string_literal: true

require "rails_helper"

# each team has 4 rosters, players have roster spot/level

RSpec.describe Roster, type: :model do
  let(:team) { Fabricate(:team) }
  let(:player) { Fabricate(:player, primary_position: 3, defense3: 1) }

  before do
    Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
      end

      context "when level is 4" do
        before { subject.level = 4 }

        context "for a starting pitcher" do
          let(:player) { Fabricate(:starting_pitcher, relief_pitching: nil) }

          before do
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
            Fabricate(:contract, team: team, player: player)
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
          Fabricate.build(:roster, team: team, player: player, level: 4,
                                   position: 3)
        end

        context "when already 25 at level 4" do
          before { 25.times { Fabricate(:roster, team: team, level: 4) } }

          it "should be valid" do
            expect(roster).to be_valid
          end
        end

        context "when already 26 at level 4" do
          before { 26.times { Fabricate(:roster, team: team, level: 4) } }

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

      context "for a persisted roster" do
        let!(:roster) do
          Fabricate(:roster, team: team, player: player, level: 4, position: 3)
        end

        context "when already 25 at level 4" do
          before { 25.times { Fabricate(:roster, team: team, level: 4) } }

          it "should be valid" do
            expect(roster).to be_valid
          end
        end
      end
    end
  end

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
        it "returns nil" do
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
        it "returns nil" do
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
        it "returns nil" do
          expect(Roster.position_initials(2, 4)).to eq("C")
        end
      end

      context "when position is 3" do
        it "returns 'IF'" do
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

        it "returns nil" do
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

        it "returns nil" do
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
end
