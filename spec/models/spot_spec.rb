# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spot, type: :model do
  let(:team) { Fabricate(:team) }
  let(:lineup) { Fabricate(:lineup, team: team) }
  let(:hitter) { Fabricate(:hitter, primary_position: 2, defense2: 5) }
  let(:roster) do
    Fabricate(:roster, player: hitter, team: team, level: 4, position: 2)
  end

  before do
    roster
    @spot = Spot.new(lineup_id: lineup.id, hitter_id: hitter.id,
                     position: 2, batting_order: 1)
  end

  subject { @spot }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:lineup_id) }
  it { is_expected.to validate_presence_of(:hitter_id) }
  it { is_expected.to validate_presence_of(:position) }
  it { is_expected.to validate_presence_of(:batting_order) }

  it { is_expected.to validate_inclusion_of(:position).in_range(2..9) }
  it { is_expected.to validate_inclusion_of(:batting_order).in_range(1..9) }

  it do
    is_expected.to validate_uniqueness_of(:batting_order).scoped_to(:lineup_id)
  end
  it { is_expected.to validate_uniqueness_of(:hitter_id).scoped_to(:lineup_id) }

  it { is_expected.to belong_to(:lineup) }
  it { is_expected.to belong_to(:hitter) }

  describe "#validate" do
    describe "#position_available" do
      context "when already 1 of each position" do
        before do
          subject.position = nil
          subject.batting_order = 8

          [2, 3, 4, 5, 6, 7, 8].each_with_index do |position, index|
            Fabricate(:spot, lineup: lineup, position: position,
                             batting_order: (index + 1))
          end
        end

        context "and position is 7" do
          before do
            subject.position = 7
            hitter.update(defense7: -3)
            roster.update(position: 7)
          end

          it { is_expected.to be_valid }
        end

        context "and position is 2" do
          before do
            subject.position = 2
            roster.update(position: 2)
          end

          it { is_expected.not_to be_valid }
        end
      end

      context "when changing batting_order" do
        let!(:spot) { Fabricate(:spot, batting_order: 2) }

        it "allows it" do
          expect do
            spot.batting_order = 3
            spot.save
            spot.reload
          end.to change(spot, :batting_order).to(3)
        end
      end
    end

    describe "#correct_batters_amount" do
      let(:lineup) { Fabricate(:lineup, team: team) }

      context "when no DH" do
        context "for first batting spot" do
          before { subject.batting_order = 1 }

          it { is_expected.to be_valid }
        end

        context "for 9th batting_order" do
          before { subject.batting_order = 9 }

          it { is_expected.not_to be_valid }
        end

        context "for 0 batting_order" do
          before { subject.batting_order = 0 }

          it { is_expected.not_to be_valid }
        end

        context "for -1 batting_order" do
          before { subject.batting_order = -1 }

          it { is_expected.not_to be_valid }
        end
      end

      context "when DH" do
        let(:lineup) { Fabricate(:dh_lineup, team: team) }

        context "for 8th batting_order" do
          before { subject.batting_order = 8 }

          it { is_expected.to be_valid }
        end

        context "for 9th batting_order" do
          before { subject.batting_order = 9 }

          it { is_expected.to be_valid }
        end

        context "for 10th batting_order" do
          before { subject.batting_order = 10 }

          it { is_expected.not_to be_valid }
        end
      end
    end

    describe "#hitter_on_team" do
      context "when no contract" do
        let(:lineup) { Fabricate(:lineup) }

        before do
          subject.lineup = lineup
          subject.hitter = hitter
        end

        it { is_expected.not_to be_valid }
      end
    end

    describe "#hitter_on_level" do
      context "when contract, but no roster" do
        let(:roster) { nil }

        it { is_expected.not_to be_valid }
      end

      context "when level 3 roster" do
        let(:roster) do
          Fabricate(:roster, team: team, player: hitter, level: 3, position: 3)
        end

        it { is_expected.not_to be_valid }
      end
    end
  end

  describe "#defense" do
    context "for position 1" do
      context "when player plays the position" do
        let(:player) { Fabricate(:starting_pitcher, defense1: -1) }

        before do
          subject.position = 1
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(-1)
        end
      end

      context "when player doesn't play the position" do
        let(:player) { Fabricate(:hitter, defense1: nil) }

        before do
          subject.position = 1
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-10)
        end
      end
    end

    context "for position 2" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 2, defense2: 2) }

        before do
          subject.position = 2
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) { Fabricate(:hitter, primary_position: 3, defense2: nil) }

        before do
          subject.position = 2
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-25)
        end
      end
    end

    context "for position 3" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 3, defense3: 2) }

        before do
          subject.position = 3
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) { Fabricate(:hitter, primary_position: 2, defense3: nil) }

        before do
          subject.position = 3
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-10)
        end
      end
    end

    context "for position 4" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 4, defense4: 2) }

        before do
          subject.position = 4
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) do
          Fabricate(:hitter, primary_position: 2, defense4: nil)
        end

        before do
          subject.position = 4
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-20)
        end
      end
    end

    context "for position 5" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 5, defense5: 2) }

        before do
          subject.position = 5
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) do
          Fabricate(:hitter, primary_position: 2, defense5: nil)
        end

        before do
          subject.position = 5
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-10)
        end
      end
    end

    context "for position 6" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 6, defense6: 2) }

        before do
          subject.position = 6
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) do
          Fabricate(:hitter, primary_position: 2, defense6: nil)
        end

        before do
          subject.position = 6
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-20)
        end
      end
    end

    context "for position 7" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 7, defense7: 2) }

        before do
          subject.position = 7
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) do
          Fabricate(:hitter, primary_position: 2, defense7: nil)
        end

        before do
          subject.position = 7
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-10)
        end
      end
    end

    context "for position 8" do
      context "when player plays the position" do
        let(:player) { Fabricate(:hitter, primary_position: 8, defense8: 2) }

        before do
          subject.position = 8
          subject.hitter = player
        end

        it "returns their score" do
          expect(subject.defense).to eq(2)
        end
      end

      context "when player doesn't play the position" do
        let(:player) do
          Fabricate(:hitter, primary_position: 2, defense8: nil)
        end

        before do
          subject.position = 8
          subject.hitter = player
        end

        it "returns nil" do
          expect(subject.defense).to eq(-10)
        end
      end
    end

    context "for position 9" do
      let(:player) { Fabricate(:hitter) }

      before do
        subject.position = 9
        subject.hitter = player
      end

      it "returns 0" do
        expect(subject.defense).to eq(0)
      end
    end
  end

  describe "#position_initials" do
    context "when position is nil" do
      it "returns nil" do
        subject.position = nil
        expect(subject.position_initials).to eq(nil)
      end
    end

    context "when position is 0" do
      it "returns nil" do
        subject.position = 0
        expect(subject.position_initials).to eq(nil)
      end
    end

    context "when position is 1" do
      it "returns 'P'" do
        subject.position = 1
        expect(subject.position_initials).to eq("P")
      end
    end

    context "when position is 2" do
      it "returns 'C'" do
        subject.position = 2
        expect(subject.position_initials).to eq("C")
      end
    end

    context "when position is 3" do
      it "returns '1B'" do
        subject.position = 3
        expect(subject.position_initials).to eq("1B")
      end
    end

    context "when position is 4" do
      it "returns '2B'" do
        subject.position = 4
        expect(subject.position_initials).to eq("2B")
      end
    end

    context "when position is 5" do
      it "returns '3B'" do
        subject.position = 5
        expect(subject.position_initials).to eq("3B")
      end
    end

    context "when position is 6" do
      it "returns 'SS'" do
        subject.position = 6
        expect(subject.position_initials).to eq("SS")
      end
    end

    context "when position is 7" do
      it "returns 'OF'" do
        subject.position = 7
        expect(subject.position_initials).to eq("OF")
      end
    end

    context "when position is 8" do
      it "returns 'CF'" do
        subject.position = 8
        expect(subject.position_initials).to eq("CF")
      end
    end

    context "when position is 9" do
      it "returns 'DH'" do
        subject.position = 9
        expect(subject.position_initials).to eq("DH")
      end
    end
  end
end
