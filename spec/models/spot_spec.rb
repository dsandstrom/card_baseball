# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spot, type: :model do
  let(:lineup) { Fabricate(:lineup) }
  let(:hitter) { Fabricate(:hitter, catcher_defense: 5) }

  before do
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
            hitter.update(outfield_defense: -3)
          end

          it { is_expected.to be_valid }
        end

        context "and position is 3" do
          before { subject.position = 2 }

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

    describe "#hitter_plays_position" do
      context "when position is 4" do
        before { subject.position = 4 }

        context "and hitter has a defense score" do
          before { hitter.update(second_base_defense: 1) }

          it { is_expected.to be_valid }
        end

        context "and hitter doesn't have a defense score" do
          before { hitter.update(second_base_defense: nil) }

          it { is_expected.not_to be_valid }
        end
      end

      context "when position is 9" do
        before { subject.position = 9 }

        it { is_expected.to be_valid }
      end
    end

    describe "#correct_batters_amount" do
      let(:lineup) { Fabricate(:lineup) }

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
        let(:lineup) { Fabricate(:dh_lineup) }

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
  end

  describe "#defense" do
    let(:hitter) do
      Fabricate(:hitter, first_base_defense: 1, second_base_defense: -1)
    end

    context "when no hitter" do
      let(:spot) { Fabricate.build(:spot, hitter: nil, position: 3) }

      it "returns nil" do
        expect(spot.defense).to be_nil
      end
    end

    context "when no position" do
      let(:spot) { Fabricate.build(:spot, hitter: hitter, position: nil) }

      it "returns nil" do
        expect(spot.defense).to be_nil
      end
    end

    context "when hitter plays the position" do
      let(:spot) { Fabricate(:spot, hitter: hitter, position: 3) }

      it "returns their score" do
        expect(spot.defense).to eq(1)
      end
    end

    context "when hitter doesn't play the position" do
      let(:spot) { Fabricate.build(:spot, hitter: hitter, position: 7) }

      it "returns nil" do
        expect(spot.defense).to be_nil
      end
    end
  end
end
