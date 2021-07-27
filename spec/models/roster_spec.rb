# frozen_string_literal: true

require "rails_helper"

# each team has 4 rosters, players have roster spot/level

RSpec.describe Roster, type: :model do
  let(:team) { Fabricate(:team) }
  let(:player) do
    Fabricate(:player, primary_position: 4, defense4: 1)
  end

  before do
    Fabricate(:contract, team: team, player: player)
    @roster = Roster.new(team_id: team.id, player_id: player.id,
                         level: 1, position: 3)
  end

  subject { @roster }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of :team_id }
  it { is_expected.to validate_presence_of :player_id }
  it { is_expected.to validate_presence_of :level }
  it { is_expected.to validate_presence_of :position }

  it { is_expected.to validate_inclusion_of(:position).in_array([1, 3, 7, 10]) }
  it { is_expected.to validate_inclusion_of(:level).in_array([1, 2, 3, 4]) }

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
  end
end
