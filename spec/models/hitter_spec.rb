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

  it { is_expected.to have_one(:hitter_contract) }
  it { is_expected.to have_one(:team) }

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
end
