# frozen_string_literal: true

require "rails_helper"

RSpec.describe Spot, type: :model do
  let(:lineup) { Fabricate(:lineup) }
  let(:hitter) { Fabricate(:hitter) }

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

  it { is_expected.to validate_uniqueness_of(:position).scoped_to(:lineup_id) }
  it do
    is_expected.to validate_uniqueness_of(:batting_order).scoped_to(:lineup_id)
  end
  it { is_expected.to validate_uniqueness_of(:hitter_id).scoped_to(:lineup_id) }

  it { is_expected.to belong_to(:lineup) }
  it { is_expected.to belong_to(:hitter) }

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
      let(:spot) { Fabricate(:spot, hitter: hitter, position: 7) }

      it "returns nil" do
        expect(spot.defense).to be_nil
      end
    end
  end
end
