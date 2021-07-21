# frozen_string_literal: true

require "rails_helper"

RSpec.describe Player, type: :model do
  let(:team) { Fabricate(:team) }

  before do
    @player = Player.new(
      first_name: "Tony",
      last_name: "Gwynn",
      roster_name: "Gwynn",
      bats: "L",
      bunt_grade: "A",
      primary_position: 7,
      speed: 4,
      offensive_durability: 88,
      offensive_rating: 75,
      left_hitting: 66,
      right_hitting: 76,
      left_on_base_percentage: 82,
      left_slugging: 52,
      left_homerun: 17,
      right_on_base_percentage: 91,
      right_slugging: 58,
      right_homerun: 17
    )
  end

  subject { @player }

  it { is_expected.to be_valid }

  it { is_expected.to validate_length_of(:first_name).is_at_most(200) }
  it { is_expected.to validate_length_of(:nick_name).is_at_most(200) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(200) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_length_of(:roster_name).is_at_most(200) }
  it { is_expected.to validate_presence_of(:roster_name) }
  it { is_expected.to validate_uniqueness_of(:roster_name).case_insensitive }
  it { is_expected.to validate_presence_of(:bats) }
  it { is_expected.to validate_inclusion_of(:bats).in_array(%w[R L B]) }
  it { is_expected.to validate_inclusion_of(:throws).in_array(%w[L R]) }
  it { is_expected.to validate_presence_of(:bunt_grade) }
  it { is_expected.to validate_inclusion_of(:bunt_grade).in_array(%w[A B]) }
  it { is_expected.to validate_presence_of(:speed) }
  it { is_expected.to validate_inclusion_of(:speed).in_range(0..6) }
  it { is_expected.to validate_presence_of(:primary_position) }
  it { is_expected.to validate_inclusion_of(:primary_position).in_range(1..8) }
  it do
    is_expected.to validate_inclusion_of(:offensive_durability).in_range(0..130)
  end
  it do
    is_expected.to validate_inclusion_of(:pitching_durability).in_range(0..130)
  end
  it { is_expected.to validate_presence_of(:offensive_rating) }
  it do
    is_expected.to validate_inclusion_of(:offensive_rating).in_range(0..130)
  end
  it { is_expected.to validate_inclusion_of(:pitcher_rating).in_range(0..130) }
  it { is_expected.to validate_presence_of(:left_hitting) }
  it { is_expected.to validate_inclusion_of(:left_hitting).in_range(0..130) }
  it { is_expected.to validate_presence_of(:right_hitting) }
  it { is_expected.to validate_inclusion_of(:right_hitting).in_range(0..130) }
  it { is_expected.to validate_presence_of(:left_on_base_percentage) }
  it do
    is_expected.to validate_inclusion_of(:left_on_base_percentage)
      .in_range(0..130)
  end
  it { is_expected.to validate_presence_of(:right_on_base_percentage) }
  it do
    is_expected.to validate_inclusion_of(:right_on_base_percentage)
      .in_range(0..130)
  end
  it { is_expected.to validate_presence_of(:left_slugging) }
  it { is_expected.to validate_inclusion_of(:left_slugging).in_range(0..130) }
  it { is_expected.to validate_presence_of(:right_slugging) }
  it { is_expected.to validate_inclusion_of(:right_slugging).in_range(0..130) }
  it { is_expected.to validate_presence_of(:left_homerun) }
  it { is_expected.to validate_inclusion_of(:left_homerun).in_range(0..130) }
  it { is_expected.to validate_presence_of(:right_homerun) }
  it { is_expected.to validate_inclusion_of(:right_homerun).in_range(0..130) }
  it { is_expected.to validate_inclusion_of(:defense1).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense2).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense3).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense4).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense5).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense6).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense7).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:defense8).in_range(-20..20) }
  it { is_expected.to validate_inclusion_of(:bar1).in_range(-5..5) }
  it { is_expected.to validate_inclusion_of(:bar2).in_range(-5..5) }
  it { is_expected.to validate_inclusion_of(:pitcher_type).in_array(%w[R S]) }
  it do
    is_expected.to validate_inclusion_of(:starting_pitching).in_range(0..130)
  end
  it { is_expected.to validate_inclusion_of(:relief_pitching).in_range(0..130) }

  it { is_expected.to have_one(:contract) }
  it { is_expected.to have_one(:team) }
  it { is_expected.to have_many(:spots).dependent(:destroy) }
  it { is_expected.to have_many(:lineups) }

  # CLASS

  describe ".position_form_options" do
    it "returns [position name, position number] format" do
      expect(Player.position_form_options).to eq(
        [["Pitcher", 1], ["Catcher", 2], ["First Base", 3], ["Second Base", 4],
         ["Third Base", 5], ["Shortstop", 6], ["Outfield", 7],
         ["Center Field", 8]]
      )
    end
  end

  describe ".position_initials" do
    context "when given 0" do
      it "returns nil" do
        expect(Player.position_initials(0)).to eq(nil)
      end
    end

    context "when given 1" do
      it "returns 'P'" do
        expect(Player.position_initials(1)).to eq("P")
      end
    end

    context "when given 2" do
      it "returns 'C'" do
        expect(Player.position_initials(2)).to eq("C")
      end
    end

    context "when given 3" do
      it "returns '1B'" do
        expect(Player.position_initials(3)).to eq("1B")
      end
    end

    context "when given 4" do
      it "returns '2B'" do
        expect(Player.position_initials(4)).to eq("2B")
      end
    end

    context "when given 5" do
      it "returns '3B'" do
        expect(Player.position_initials(5)).to eq("3B")
      end
    end

    context "when given 6" do
      it "returns 'SS'" do
        expect(Player.position_initials(6)).to eq("SS")
      end
    end

    context "when given 7" do
      it "returns 'OF'" do
        expect(Player.position_initials(7)).to eq("OF")
      end
    end

    context "when given 8" do
      it "returns 'CF'" do
        expect(Player.position_initials(8)).to eq("CF")
      end
    end

    context "when given 9" do
      it "returns 'DH'" do
        expect(Player.position_initials(9)).to eq("DH")
      end
    end
  end

  describe ".position_name" do
    context "when given 0" do
      it "returns nil" do
        expect(Player.position_name(0)).to eq(nil)
      end
    end

    context "when given 1" do
      it "returns 'Pitcher'" do
        expect(Player.position_name(1)).to eq("Pitcher")
      end
    end

    context "when given 2" do
      it "returns 'Catcher'" do
        expect(Player.position_name(2)).to eq("Catcher")
      end
    end

    context "when given 3" do
      it "returns 'First Base'" do
        expect(Player.position_name(3)).to eq("First Base")
      end
    end

    context "when given 4" do
      it "returns 'Second Base'" do
        expect(Player.position_name(4)).to eq("Second Base")
      end
    end

    context "when given 5" do
      it "returns 'Third Base'" do
        expect(Player.position_name(5)).to eq("Third Base")
      end
    end

    context "when given 6" do
      it "returns 'Shortstop'" do
        expect(Player.position_name(6)).to eq("Shortstop")
      end
    end

    context "when given 7" do
      it "returns 'Outfield'" do
        expect(Player.position_name(7)).to eq("Outfield")
      end
    end

    context "when given 8" do
      it "returns 'Center Field'" do
        expect(Player.position_name(8)).to eq("Center Field")
      end
    end

    context "when given 9" do
      it "returns 'Designated Hitter'" do
        expect(Player.position_name(9)).to eq("Designated Hitter")
      end
    end
  end

  describe ".hitters" do
    let(:first_base) do
      Fabricate(:player, defense3: 1, defense7: -1, primary_position: 3,
                         offensive_rating: 80)
    end
    let(:outfield) do
      Fabricate(:player, defense7: -2, primary_position: 3,
                         offensive_rating: 90)
    end
    let(:pitcher) do
      Fabricate(:player, defense1: 1, bar1: 2, primary_position: 1,
                         hitting_pitcher: false)
    end
    let(:hitting_pitcher) do
      Fabricate(:player, defense1: 2, defense3: 1, primary_position: 1,
                         hitting_pitcher: true)
    end

    context "when no players" do
      it "returns []" do
        expect(Player.hitters).to eq([])
      end
    end

    context "when a first baseman and pitcher" do
      before do
        first_base
        pitcher
      end

      it "returns first_base" do
        expect(Player.hitters).to eq([first_base])
      end
    end

    context "when an outfielder" do
      before { outfield }

      it "returns outfield" do
        expect(Player.hitters).to eq([outfield])
      end
    end

    context "when a hitting_pitcher" do
      before { hitting_pitcher }

      it "returns hitting_pitcher" do
        expect(Player.hitters).to eq([hitting_pitcher])
      end
    end
  end

  describe ".pitchers" do
    let(:first_base) do
      Fabricate(:player, defense3: 1, defense7: -1, primary_position: 3,
                         offensive_rating: 80)
    end
    let(:outfield) do
      Fabricate(:player, defense7: -2, primary_position: 3,
                         offensive_rating: 90)
    end
    let(:pitcher) do
      Fabricate(:player, defense1: 0, bar1: 2, primary_position: 1,
                         pitcher_type: "S", throws: "R", pitcher_rating: 70,
                         hitting_pitcher: false)
    end
    let(:hitting_pitcher) do
      Fabricate(:player, defense1: 2, defense3: 1, primary_position: 1,
                         pitcher_type: "S", throws: "R", pitcher_rating: 80,
                         hitting_pitcher: true)
    end

    context "when no players" do
      it "returns []" do
        expect(Player.pitchers).to eq([])
      end
    end

    context "when a first baseman, outfielder and pitcher" do
      before do
        first_base
        outfield
        pitcher
      end

      it "returns pitcher" do
        expect(Player.pitchers).to eq([pitcher])
      end
    end

    context "when a hitting_pitcher" do
      before { hitting_pitcher }

      it "returns them" do
        expect(Player.pitchers).to eq([hitting_pitcher])
      end
    end
  end

  describe ".filter_by" do
    context "when no players" do
      it "returns []" do
        expect(Player.filter_by).to eq([])
      end
    end

    context "when no filters" do
      let!(:player) { Fabricate(:player) }

      it "returns all players" do
        expect(Player.filter_by).to eq([player])
      end
    end

    context "when query filter" do
      let!(:first_player) do
        Fabricate(:player, first_name: "Al", nick_name: "Pha",
                           last_name: "Beta")
      end
      let!(:second_player) do
        Fabricate(:player, first_name: "Gam", nick_name: "Ma",
                           last_name: "Detla")
      end

      it "returns all players that match by their first_name" do
        expect(Player.filter_by(query: "Al")).to eq([first_player])
      end

      it "returns all players that match by their nick_name" do
        expect(Player.filter_by(query: "ma")).to eq([second_player])
      end

      it "returns all players that match by their last_name" do
        expect(Player.filter_by(query: "Eta")).to eq([first_player])
      end
    end

    context "when free_agent filter" do
      let!(:first_player) { Fabricate(:player) }
      let!(:second_player) { Fabricate(:player) }
      let!(:third_player) { Fabricate(:player) }

      before do
        Fabricate(:contract, player: first_player, team: team)
        Fabricate(:contract, player: second_player)
      end

      it "returns all players that have no contract or no team" do
        expect(Player.filter_by(free_agent: "true"))
          .to contain_exactly(second_player, third_player)
      end
    end

    context "when position1 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 1) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position1: "true")).to eq([first_player])
      end
    end

    context "when position2 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 2) }
      let!(:second_player) { Fabricate(:player, primary_position: 3) }

      it "returns all players that play position" do
        expect(Player.filter_by(position2: "true")).to eq([first_player])
      end
    end

    context "when position3 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 3) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position3: "true")).to eq([first_player])
      end
    end

    context "when position4 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 4) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position4: "true")).to eq([first_player])
      end
    end

    context "when position5 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 5) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position5: "true")).to eq([first_player])
      end
    end

    context "when position6 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 6) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position6: "true")).to eq([first_player])
      end
    end

    context "when position7 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 7) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position7: "true")).to eq([first_player])
      end
    end

    context "when position8 filter" do
      let!(:first_player) { Fabricate(:player, primary_position: 8) }
      let!(:second_player) { Fabricate(:player, primary_position: 2) }

      it "returns all players that play position" do
        expect(Player.filter_by(position8: "true")).to eq([first_player])
      end
    end

    context "when position5 and position6 filters" do
      let!(:first_player) do
        Fabricate(:player, primary_position: 5, defense3: 1)
      end
      let!(:second_player) { Fabricate(:player, primary_position: 6) }
      let!(:third_player) { Fabricate(:player, primary_position: 7) }

      it "returns all players that play either position" do
        expect(Player.filter_by(position5: "true", position6: "true"))
          .to contain_exactly(first_player, second_player)
      end
    end

    context "when query and free_agent filters" do
      let!(:first_player) do
        Fabricate(:player, first_name: "Al", last_name: "Pha")
      end
      let!(:second_player) do
        Fabricate(:player, first_name: "Al", last_name: "Pho")
      end

      before do
        Fabricate(:contract, player: first_player, team: team)
      end

      it "returns players that match all filters" do
        expect(Player.filter_by(free_agent: "true", query: "al"))
          .to eq([second_player])
      end
    end
  end

  # INSTANCE

  describe "#name" do
    let(:player) { Fabricate.build(:player) }

    context "when all names nil" do
      before do
        player.first_name = nil
        player.nick_name = nil
        player.last_name = nil
      end

      it "returns ''" do
        expect(player.name).to eq("")
      end
    end

    context "when first_name is not nil" do
      before do
        player.first_name = "Tom"
        player.nick_name = nil
        player.last_name = nil
      end

      it "returns ''" do
        expect(player.name).to eq("Tom")
      end
    end

    context "when last_name is not nil" do
      before do
        player.first_name = nil
        player.nick_name = nil
        player.last_name = "Glavine"
      end

      it "returns ''" do
        expect(player.name).to eq("Glavine")
      end
    end

    context "when first and last names " do
      before do
        player.first_name = " Tom"
        player.nick_name = nil
        player.last_name = "Glavine"
      end

      it "returns ''" do
        expect(player.name).to eq("Tom Glavine")
      end
    end

    context "when all names " do
      before do
        player.first_name = "Tom"
        player.nick_name = "South Paw"
        player.last_name = "Glavine"
      end

      it "returns ''" do
        expect(player.name).to eq('Tom "South Paw" Glavine')
      end
    end
  end

  describe "#set_roster_name" do
    let(:player) { Fabricate.build(:player, roster_name: nil) }

    context "when roster_name is set" do
      before do
        player.last_name = "Something Else"
        player.roster_name = "Something"
      end

      it "doesn't change it" do
        expect do
          player.set_roster_name
        end.not_to change(player, :roster_name)
        expect(player).to be_valid
      end
    end

    context "when last_name is blank" do
      before do
        player.last_name = ""
      end

      it "doesn't change it" do
        expect do
          player.set_roster_name
        end.not_to change(player, :roster_name)
        expect(player).not_to be_valid
      end
    end

    context "when roster_name is blank" do
      before do
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "changes it the last_name" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Hoffman")
        expect(player).to be_valid
      end
    end

    context "when last_name is already taken" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("T.Hoffman")
        expect(player).to be_valid
      end
    end

    context "when first_name initial is already taken" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        Fabricate(:player, roster_name: "T.Hoffman")
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Tr.Hoffman")
        expect(player).to be_valid
      end
    end

    context "when last_name is already taken and no first name" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        player.first_name = nil
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Hoffman")
        expect(player).not_to be_valid
      end
    end
  end

  describe "#set_roster_name" do
    let(:player) { Fabricate.build(:player, roster_name: nil) }

    context "when roster_name is set" do
      before do
        player.last_name = "Something Else"
        player.roster_name = "Something"
      end

      it "doesn't change it" do
        expect do
          player.set_roster_name
        end.not_to change(player, :roster_name)
        expect(player).to be_valid
      end
    end

    context "when last_name is blank" do
      before do
        player.last_name = ""
      end

      it "doesn't change it" do
        expect do
          player.set_roster_name
        end.not_to change(player, :roster_name)
        expect(player).not_to be_valid
      end
    end

    context "when roster_name is blank" do
      before do
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "changes it the last_name" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Hoffman")
        expect(player).to be_valid
      end
    end

    context "when last_name is already taken" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("T.Hoffman")
        expect(player).to be_valid
      end
    end

    context "when first_name initial is already taken" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        Fabricate(:player, roster_name: "T.Hoffman")
        player.first_name = "Trevor"
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Tr.Hoffman")
        expect(player).to be_valid
      end
    end

    context "when last_name is already taken and no first name" do
      before do
        Fabricate(:player, roster_name: "Hoffman")
        player.first_name = nil
        player.last_name = "Hoffman"
      end

      it "adds first name initial" do
        expect do
          player.set_roster_name
        end.to change(player, :roster_name).to("Hoffman")
        expect(player).not_to be_valid
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
    let(:player) do
      Fabricate(:player, primary_position: 3, defense3: 1, defense4: -1)
    end

    context "when player plays the position" do
      it "returns their score" do
        expect(player.position_defense(4)).to eq(-1)
      end
    end

    context "when player doesn't play the position" do
      it "returns nil" do
        expect(player.position_defense(8)).to be_nil
      end
    end

    context "when position is 9" do
      it "returns 0" do
        expect(player.position_defense(9)).to eq(0)
      end
    end
  end

  describe "#positions" do
    let(:player) { Fabricate(:player, primary_position: 3) }

    context "when no defense" do
      before { player.update defense3: nil }

      it "returns []" do
        expect(player.positions).to eq([])
      end
    end

    context "when defense1" do
      let(:player) do
        Fabricate(:player, primary_position: 1, defense1: 1, bar1: 2,
                           hitting_pitcher: true)
      end

      it "returns [1]" do
        expect(player.positions).to eq([1])
      end
    end

    context "when defense2" do
      let(:player) { Fabricate(:player, primary_position: 2, defense2: 2) }

      it "returns [2]" do
        expect(player.positions).to eq([2])
      end
    end

    context "when defense3 and defense7" do
      let(:player) do
        Fabricate(:player, primary_position: 3, defense3: 0, defense7: -1)
      end

      it "returns [3, 7]" do
        expect(player.positions).to eq([3, 7])
      end
    end
  end

  describe "#bar_for_position" do
    let(:player) do
      Fabricate(:player, primary_position: 2, defense2: 1, bar2: 2, bar1: 3,
                         defense3: 4)
    end

    context "for position 1" do
      it "returns their bar1" do
        expect(player.bar_for_position(1)).to eq(3)
      end
    end

    context "for position 2" do
      it "returns their bar2" do
        expect(player.bar_for_position(2)).to eq(2)
      end
    end

    context "for position 3" do
      it "returns nil" do
        expect(player.bar_for_position(3)).to be_nil
      end
    end
  end
end
