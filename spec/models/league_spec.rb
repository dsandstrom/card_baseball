# frozen_string_literal: true

require "rails_helper"

RSpec.describe League, type: :model do
  before do
    @league = League.new(name: "National")
  end

  subject { @league }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  it { is_expected.to have_many(:teams) }

  describe "#full_name" do
    context "when name is blank" do
      before { subject.name = "" }

      it "returns blank" do
        expect(subject.full_name).to be_nil
      end
    end

    context "when name is something" do
      before { subject.name = "Something" }

      it "adds League to the end" do
        expect(subject.full_name).to eq("Something League")
      end
    end
  end
end
