# frozen_string_literal: true

require "rails_helper"

RSpec.describe Lineup, type: :model do
  let(:team) { Fabricate(:team) }

  before do
    @lineup = Lineup.new(name: "Main", team_id: team.id)
  end

  subject { @lineup }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:team_id) }

  it do
    is_expected.to validate_uniqueness_of(:name)
      .scoped_to(%i[team_id vs with_dh]).case_insensitive
  end

  it do
    is_expected.to validate_inclusion_of(:vs).in_array([nil, "left", "right"])
  end

  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:spots) }
  it { is_expected.to have_many(:hitters) }

  describe "#validate" do
    context "when name and vs are blank" do
      before do
        subject.name = ""
        subject.vs = ""
      end

      it { is_expected.not_to be_valid }
    end

    context "when vs is not blank" do
      before do
        subject.name = ""
        subject.vs = "left"
      end

      it { is_expected.to be_valid }
    end
  end

  # INSTANCE

  describe ".position_form_options" do
    context "when with_dh is false" do
      before { subject.with_dh = false }

      it "returns [position initials, position number] format" do
        expect(subject.position_form_options).to eq(
          [["C", 2], ["1B", 3], ["2B", 4], ["3B", 5], ["SS", 6], ["OF", 7],
           ["CF", 8]]
        )
      end
    end

    context "when with_dh is false" do
      before { subject.with_dh = true }

      it "returns [position initials, position number] format" do
        expect(subject.position_form_options).to eq(
          [["C", 2], ["1B", 3], ["2B", 4], ["3B", 5], ["SS", 6], ["OF", 7],
           ["CF", 8], ["DH", 9]]
        )
      end
    end
  end

  describe "#full_name" do
    context "when name, vs, with_dh are blank" do
      before do
        subject.name = ""
        subject.vs = ""
        subject.with_dh = false
      end

      it "returns nil" do
        expect(subject.full_name).to be_nil
      end
    end

    context "when name is something" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = false
      end

      it "returns name only" do
        expect(subject.full_name).to eq("Something")
      end
    end

    context "when name is something with DH" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = true
      end

      it "returns name and DH" do
        expect(subject.full_name).to eq("Something (DH)")
      end
    end

    context "when vs is something" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns 'vs Lefty'" do
        expect(subject.full_name).to eq("vs Lefty")
      end
    end

    context "when vs is something with DH" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns 'vs Lefty (DH)'" do
        expect(subject.full_name).to eq("vs Lefty (DH)")
      end
    end

    context "when name is something and vs is left" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.full_name).to eq("Main vs Lefty")
      end
    end

    context "when name is something and vs is right" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.full_name).to eq("Main vs Righty")
      end
    end

    context "when name is something and vs is left with DH" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns name, vs, DH" do
        expect(subject.full_name).to eq("Main vs Lefty (DH)")
      end
    end

    context "when name is something and vs is right with DH" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = true
      end

      it "returns name, vs, DH" do
        expect(subject.full_name).to eq("Main vs Righty (DH)")
      end
    end
  end

  describe "#remove_dh_spot" do
    let(:lineup) { Fabricate(:dh_lineup) }

    before { Fabricate(:spot, lineup: lineup, batting_order: 2, position: 2) }

    context "when the dh spot and 9th batting order are empty" do
      it "doesn't destroy any spots" do
        expect do
          lineup.remove_dh_spot
        end.not_to change(lineup.spots, :count)
      end
    end

    context "when the dh spot taken" do
      before { Fabricate(:spot, lineup: lineup, batting_order: 3, position: 9) }

      it "destroys the spot" do
        expect do
          lineup.remove_dh_spot
        end.to change(lineup.spots, :count).by(-1)
      end
    end

    context "when 9th batting_order taken" do
      before { Fabricate(:spot, lineup: lineup, batting_order: 9, position: 7) }

      it "destroys the spot" do
        expect do
          lineup.remove_dh_spot
        end.to change(lineup.spots, :count).by(-1)
      end
    end

    context "when dh is batting 9th" do
      before { Fabricate(:spot, lineup: lineup, batting_order: 9, position: 9) }

      it "destroys the spot" do
        expect do
          lineup.remove_dh_spot
        end.to change(lineup.spots, :count).by(-1)
      end
    end
  end

  describe "#bench" do
    let(:lineup) { Fabricate(:lineup, team: team) }

    context "when no hitters" do
      it "returns []" do
        expect(lineup.bench).to eq([])
      end
    end

    context "when team has 2 hitters" do
      let(:first_hitter) { Fabricate(:hitter, catcher_defense: 2) }
      let(:second_hitter) { Fabricate(:hitter, first_base_defense: 5) }

      before do
        Fabricate(:hitter_contract, team: team, hitter: first_hitter)
        Fabricate(:hitter_contract, team: team, hitter: second_hitter)
        Fabricate(:hitter_contract)
      end

      context "and none in the lineup" do
        it "returns both" do
          expect(lineup.bench).to match_array([first_hitter, second_hitter])
        end
      end

      context "and one in the lineup" do
        before do
          Fabricate(:spot, hitter: first_hitter, lineup: lineup, position: 2)
        end

        it "returns both" do
          expect(lineup.bench).to match_array([second_hitter])
        end
      end

      context "and both in the lineup" do
        before do
          Fabricate(:spot, hitter: first_hitter, lineup: lineup, position: 2,
                           batting_order: 1)
          Fabricate(:spot, hitter: second_hitter, lineup: lineup, position: 3,
                           batting_order: 2)
        end

        it "returns both" do
          expect(lineup.bench).to match_array([])
        end
      end
    end
  end
end
