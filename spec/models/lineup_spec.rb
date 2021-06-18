# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lineup, type: :model do
  let(:team) { Fabricate(:team) }

  before do
    @lineup = Lineup.new(name: "Main", team_id: team.id)
  end

  subject { @lineup }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:team_id) }

  it do
    is_expected.to validate_uniqueness_of(:name)
      .scoped_to(%i[team_id vs with_dh]).case_insensitive
  end

  it do
    is_expected.to validate_inclusion_of(:vs).in_array([nil, "left", "right"])
  end

  it { is_expected.to belong_to(:team) }

  describe "#full_name" do
    context "when name, vs, with_dh are blank" do
      before do
        subject.name = ""
        subject.vs = ""
        subject.with_dh = false
      end

      it "returns blank" do
        expect(subject.full_name).to be_nil
      end
    end

    context "when name is something" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = false
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Something")
      end
    end

    context "when name is something with DH" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = true
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Something (DH)")
      end
    end

    context "when vs is something" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns blank" do
        expect(subject.full_name).to be_nil
      end
    end

    context "when name is something and vs is left" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Main vs Lefty")
      end
    end

    context "when name is something and vs is right" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = false
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Main vs Righty")
      end
    end

    context "when name is something and vs is left with DH" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Main vs Lefty (DH)")
      end
    end

    context "when name is something and vs is right with DH" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = true
      end

      it "returns blank" do
        expect(subject.full_name).to eq("Main vs Righty (DH)")
      end
    end
  end
end
