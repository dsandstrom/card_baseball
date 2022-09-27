# frozen_string_literal: true

require "rails_helper"

RSpec.describe League, type: :model do
  before do
    @league = League.new(name: "National League")
  end

  subject { @league }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it do
    is_expected.to validate_inclusion_of(:row_order_position)
      .in_array(%w[down up])
  end

  it { is_expected.to have_many(:teams) }

  describe "#first?" do
    context "when only League" do
      let(:league) { Fabricate(:league) }

      it "returns true" do
        expect(league.first?).to eq(true)
      end
    end

    context "when two Leagues" do
      let!(:first_league) { Fabricate(:league) }
      let!(:second_league) { Fabricate(:league) }

      it "returns true for first ordered league" do
        expect(first_league.first?).to eq(true)
        expect(second_league.first?).to eq(false)
      end
    end

    context "when row_order_rank is nil" do
      let(:league) { Fabricate(:league) }

      before { allow(league).to receive(:row_order_rank) { nil } }

      it "returns false" do
        expect(league.first?).to eq(false)
      end
    end
  end

  describe "#last?" do
    context "when only League" do
      let(:league) { Fabricate(:league) }

      it "returns true" do
        expect(league.last?).to eq(true)
      end
    end

    context "when two Leagues" do
      let!(:first_league) { Fabricate(:league) }
      let!(:second_league) { Fabricate(:league) }

      it "returns true for second ordered league" do
        expect(first_league.last?).to eq(false)
        expect(second_league.last?).to eq(true)
      end
    end

    context "when row_order_rank is nil" do
      let(:league) { Fabricate(:league) }

      before { allow(league).to receive(:row_order_rank) { nil } }

      it "returns false" do
        expect(league.last?).to eq(false)
      end
    end
  end
end
