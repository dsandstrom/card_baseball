# frozen_string_literal: true

# TODO: can hitter durability be nil?

require "rails_helper"

RSpec.describe Hitter, type: :model do
  before do
    @hitter = Hitter.new(
      first_name: "Tony",
      middle_name: "",
      last_name: "Gwynn",
      roster_name: "Gwynn",
      bats: "L",
      bunt_grade: "A",
      primary_position: 7,
      speed: 4,
      durability: 88,
      overall_rating: 75,
      left_rating: 66,
      right_rating: 76,
      left_on_base_percentage: 82,
      left_slugging: 52,
      left_homeruns: 17,
      right_on_base_percentage: 91,
      right_slugging: 58,
      right_homeruns: 17
    )
  end

  subject { @hitter }

  it { is_expected.to be_valid }

  it { is_expected.to respond_to(:hitting_pitcher) }

  it { is_expected.to validate_length_of(:first_name).is_at_most(200) }
  it { is_expected.to validate_length_of(:middle_name).is_at_most(200) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(200) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_length_of(:roster_name).is_at_most(200) }
  it { is_expected.to validate_presence_of(:roster_name) }
  it { is_expected.to validate_uniqueness_of(:roster_name).case_insensitive }
  it { is_expected.to validate_presence_of(:bats) }
  it { is_expected.to validate_inclusion_of(:bats).in_array(%w[R L B]) }
  it { is_expected.to validate_presence_of(:bunt_grade) }
  it { is_expected.to validate_inclusion_of(:bunt_grade).in_array(%w[A B]) }
  it { is_expected.to validate_presence_of(:speed) }
  it { is_expected.to validate_inclusion_of(:speed).in_range(0..5) }
  it { is_expected.to validate_presence_of(:primary_position) }
  it { is_expected.to validate_inclusion_of(:primary_position).in_range(1..8) }
  it { is_expected.to validate_presence_of(:durability) }
  it { is_expected.to validate_inclusion_of(:durability).in_range(0..99) }
  it { is_expected.to validate_presence_of(:overall_rating) }
  it { is_expected.to validate_inclusion_of(:overall_rating).in_range(0..99) }
  it { is_expected.to validate_presence_of(:left_rating) }
  it { is_expected.to validate_inclusion_of(:left_rating).in_range(0..99) }
  it { is_expected.to validate_presence_of(:right_rating) }
  it { is_expected.to validate_inclusion_of(:right_rating).in_range(0..99) }
  it { is_expected.to validate_presence_of(:left_on_base_percentage) }
  it do
    is_expected.to validate_inclusion_of(:left_on_base_percentage)
      .in_range(0..99)
  end
  it { is_expected.to validate_presence_of(:right_on_base_percentage) }
  it do
    is_expected.to validate_inclusion_of(:right_on_base_percentage)
      .in_range(0..99)
  end
  it { is_expected.to validate_presence_of(:left_slugging) }
  it { is_expected.to validate_inclusion_of(:left_slugging).in_range(0..99) }
  it { is_expected.to validate_presence_of(:right_slugging) }
  it { is_expected.to validate_inclusion_of(:right_slugging).in_range(0..99) }
  it { is_expected.to validate_presence_of(:left_homeruns) }
  it { is_expected.to validate_inclusion_of(:left_homeruns).in_range(0..99) }
  it { is_expected.to validate_presence_of(:right_homeruns) }
  it { is_expected.to validate_inclusion_of(:right_homeruns).in_range(0..99) }
  it do
    is_expected.to validate_inclusion_of(:pitcher_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:catcher_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:first_base_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:second_base_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:third_base_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:shortstop_defense).in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:center_field_defense)
      .in_range(-20..20)
  end
  it do
    is_expected.to validate_inclusion_of(:outfield_defense).in_range(-20..20)
  end
  it { is_expected.to validate_inclusion_of(:catcher_bar).in_range(0..5) }
  it { is_expected.to validate_inclusion_of(:pitcher_bar).in_range(0..5) }

  it { is_expected.to have_one(:contract) }
  it { is_expected.to have_one(:team) }
  it { is_expected.to have_many(:spots).dependent(:destroy) }
  it { is_expected.to have_many(:lineups) }

  # CLASS

  describe ".position_form_options" do
    it "returns [position name, position number] format" do
      expect(Hitter.position_form_options).to eq(
        [["Pitcher", 1], ["Catcher", 2], ["First Base", 3], ["Second Base", 4],
         ["Third Base", 5], ["Shortstop", 6], ["Outfield", 7],
         ["Center Field", 8]]
      )
    end
  end

  describe ".position_initials" do
    context "when given 0" do
      it "returns nil" do
        expect(Hitter.position_initials(0)).to eq(nil)
      end
    end

    context "when given 1" do
      it "returns 'P'" do
        expect(Hitter.position_initials(1)).to eq("P")
      end
    end

    context "when given 2" do
      it "returns 'C'" do
        expect(Hitter.position_initials(2)).to eq("C")
      end
    end

    context "when given 3" do
      it "returns '1B'" do
        expect(Hitter.position_initials(3)).to eq("1B")
      end
    end

    context "when given 4" do
      it "returns '2B'" do
        expect(Hitter.position_initials(4)).to eq("2B")
      end
    end

    context "when given 5" do
      it "returns '3B'" do
        expect(Hitter.position_initials(5)).to eq("3B")
      end
    end

    context "when given 6" do
      it "returns 'SS'" do
        expect(Hitter.position_initials(6)).to eq("SS")
      end
    end

    context "when given 7" do
      it "returns 'OF'" do
        expect(Hitter.position_initials(7)).to eq("OF")
      end
    end

    context "when given 8" do
      it "returns 'CF'" do
        expect(Hitter.position_initials(8)).to eq("CF")
      end
    end

    context "when given 9" do
      it "returns 'DH'" do
        expect(Hitter.position_initials(9)).to eq("DH")
      end
    end
  end

  describe ".position_name" do
    context "when given 0" do
      it "returns nil" do
        expect(Hitter.position_name(0)).to eq(nil)
      end
    end

    context "when given 1" do
      it "returns 'P'" do
        expect(Hitter.position_name(1)).to eq("Pitcher")
      end
    end

    context "when given 2" do
      it "returns 'C'" do
        expect(Hitter.position_name(2)).to eq("Catcher")
      end
    end

    context "when given 3" do
      it "returns '1B'" do
        expect(Hitter.position_name(3)).to eq("First Base")
      end
    end

    context "when given 4" do
      it "returns '2B'" do
        expect(Hitter.position_name(4)).to eq("Second Base")
      end
    end

    context "when given 5" do
      it "returns '3B'" do
        expect(Hitter.position_name(5)).to eq("Third Base")
      end
    end

    context "when given 6" do
      it "returns 'SS'" do
        expect(Hitter.position_name(6)).to eq("Shortstop")
      end
    end

    context "when given 7" do
      it "returns 'OF'" do
        expect(Hitter.position_name(7)).to eq("Outfield")
      end
    end

    context "when given 8" do
      it "returns 'CF'" do
        expect(Hitter.position_name(8)).to eq("Center Field")
      end
    end

    context "when given 9" do
      it "returns 'DH'" do
        expect(Hitter.position_name(9)).to eq("Designated Hitter")
      end
    end
  end

  # INSTANCE

  describe "#name" do
    let(:hitter) { Fabricate.build(:hitter) }

    context "when all names nil" do
      before do
        hitter.first_name = nil
        hitter.middle_name = nil
        hitter.last_name = nil
      end

      it "returns ''" do
        expect(hitter.name).to eq("")
      end
    end

    context "when first_name is not nil" do
      before do
        hitter.first_name = "Tom"
        hitter.middle_name = nil
        hitter.last_name = nil
      end

      it "returns ''" do
        expect(hitter.name).to eq("Tom")
      end
    end

    context "when last_name is not nil" do
      before do
        hitter.first_name = nil
        hitter.middle_name = nil
        hitter.last_name = "Glavine"
      end

      it "returns ''" do
        expect(hitter.name).to eq("Glavine")
      end
    end

    context "when first and last names " do
      before do
        hitter.first_name = " Tom"
        hitter.middle_name = nil
        hitter.last_name = "Glavine"
      end

      it "returns ''" do
        expect(hitter.name).to eq("Tom Glavine")
      end
    end

    context "when all names " do
      before do
        hitter.first_name = "Tom"
        hitter.middle_name = "South Paw"
        hitter.last_name = "Glavine"
      end

      it "returns ''" do
        expect(hitter.name).to eq('Tom "South Paw" Glavine')
      end
    end
  end

  describe "#set_roster_name" do
    let(:hitter) { Fabricate.build(:hitter, roster_name: nil) }

    context "when roster_name is set" do
      before do
        hitter.last_name = "Something Else"
        hitter.roster_name = "Something"
      end

      it "doesn't change it" do
        expect do
          hitter.set_roster_name
        end.not_to change(hitter, :roster_name)
        expect(hitter).to be_valid
      end
    end

    context "when last_name is blank" do
      before do
        hitter.last_name = ""
      end

      it "doesn't change it" do
        expect do
          hitter.set_roster_name
        end.not_to change(hitter, :roster_name)
        expect(hitter).not_to be_valid
      end
    end

    context "when roster_name is blank" do
      before do
        hitter.first_name = "Trevor"
        hitter.last_name = "Hoffman"
      end

      it "changes it the last_name" do
        expect do
          hitter.set_roster_name
        end.to change(hitter, :roster_name).to("Hoffman")
        expect(hitter).to be_valid
      end
    end

    context "when last_name is already taken" do
      before do
        Fabricate(:hitter, roster_name: "Hoffman")
        hitter.first_name = "Trevor"
        hitter.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          hitter.set_roster_name
        end.to change(hitter, :roster_name).to("T.Hoffman")
        expect(hitter).to be_valid
      end
    end

    context "when first_name initial is already taken" do
      before do
        Fabricate(:hitter, roster_name: "Hoffman")
        Fabricate(:hitter, roster_name: "T.Hoffman")
        hitter.first_name = "Trevor"
        hitter.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          hitter.set_roster_name
        end.to change(hitter, :roster_name).to("Tr.Hoffman")
        expect(hitter).to be_valid
      end
    end

    context "when last_name is already taken and no first name" do
      before do
        Fabricate(:hitter, roster_name: "Hoffman")
        hitter.first_name = nil
        hitter.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          hitter.set_roster_name
        end.to change(hitter, :roster_name).to("Hoffman")
        expect(hitter).not_to be_valid
      end
    end
  end

  describe "#primary_position_initials" do
    context "when primary_position is nil" do
      before { subject.primary_position = nil }

      it "returns nil" do
        expect(subject.primary_position_initials).to eq(nil)
      end
    end

    context "when primary_position is ''" do
      before { subject.primary_position = "" }

      it "returns nil" do
        expect(subject.primary_position_initials).to eq(nil)
      end
    end

    context "when primary_position is 1" do
      before { subject.primary_position = 1 }

      context "and hitting_pitcher is false" do
        before { subject.hitting_pitcher = false }

        it "returns 'P'" do
          expect(subject.primary_position_initials).to eq("P")
        end
      end

      context "and hitting_pitcher is true" do
        before { subject.hitting_pitcher = true }

        it "returns 'P'" do
          expect(subject.primary_position_initials).to eq("P+H")
        end
      end
    end

    context "when primary_position is 2" do
      before { subject.primary_position = 2 }

      it "returns 'C'" do
        expect(subject.primary_position_initials).to eq("C")
      end
    end

    context "when primary_position is 3" do
      before { subject.primary_position = 3 }

      it "returns '1B'" do
        expect(subject.primary_position_initials).to eq("1B")
      end
    end

    context "when primary_position is 4" do
      before { subject.primary_position = 4 }

      it "returns '2B'" do
        expect(subject.primary_position_initials).to eq("2B")
      end
    end

    context "when primary_position is 5" do
      before { subject.primary_position = 5 }

      it "returns '3B'" do
        expect(subject.primary_position_initials).to eq("3B")
      end
    end

    context "when primary_position is 6" do
      before { subject.primary_position = 6 }

      it "returns 'SS'" do
        expect(subject.primary_position_initials).to eq("SS")
      end
    end

    context "when primary_position is 7" do
      before { subject.primary_position = 7 }

      it "returns 'OF'" do
        expect(subject.primary_position_initials).to eq("OF")
      end
    end

    context "when primary_position is 8" do
      before { subject.primary_position = 8 }

      it "returns 'CF'" do
        expect(subject.primary_position_initials).to eq("CF")
      end
    end
  end

  describe "#position_defense" do
    let(:hitter) do
      Fabricate(:hitter, first_base_defense: 1, second_base_defense: -1)
    end

    context "when hitter plays the position" do
      it "returns their score" do
        expect(hitter.position_defense(4)).to eq(-1)
      end
    end

    context "when hitter doesn't play the position" do
      it "returns nil" do
        expect(hitter.position_defense(8)).to be_nil
      end
    end

    context "when position is 9" do
      it "returns 0" do
        expect(hitter.position_defense(9)).to eq(0)
      end
    end
  end

  describe "#positions" do
    let(:hitter) { Fabricate(:hitter) }

    context "when no defense" do
      it "returns []" do
        expect(hitter.positions).to eq([])
      end
    end

    context "when pitcher_defense" do
      let(:hitter) do
        Fabricate(:hitter, pitcher_defense: 1, pitcher_bar: 2,
                           hitting_pitcher: true)
      end

      it "returns [1]" do
        expect(hitter.positions).to eq([1])
      end
    end

    context "when catcher_defense" do
      let(:hitter) { Fabricate(:hitter, catcher_defense: 2) }

      it "returns [2]" do
        expect(hitter.positions).to eq([2])
      end
    end

    context "when first_base_defense and outfield_defense" do
      let(:hitter) do
        Fabricate(:hitter, first_base_defense: 0, outfield_defense: -1)
      end

      it "returns [3, 7]" do
        expect(hitter.positions).to eq([3, 7])
      end
    end
  end

  describe "#bar_for_position" do
    let(:hitter) do
      Fabricate(:hitter, catcher_defense: 1, catcher_bar: 2, pitcher_bar: 3,
                         first_base_defense: 4)
    end

    context "for position 1" do
      it "returns their pitcher_bar" do
        expect(hitter.bar_for_position(1)).to eq(3)
      end
    end

    context "for position 2" do
      it "returns their catcher_bar" do
        expect(hitter.bar_for_position(2)).to eq(2)
      end
    end

    context "for position 3" do
      it "returns nil" do
        expect(hitter.bar_for_position(3)).to be_nil
      end
    end
  end
end
