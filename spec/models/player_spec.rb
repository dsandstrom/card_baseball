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
  it { is_expected.to have_one(:roster) }

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

  describe ".starting_pitchers" do
    let(:first_base) do
      Fabricate(:player, defense3: 1, defense7: -1, primary_position: 3,
                         offensive_rating: 80)
    end
    let(:starting_pitcher) do
      Fabricate(:player, defense1: 0, bar1: 2, primary_position: 1,
                         pitcher_type: "S", throws: "R", pitcher_rating: 70,
                         hitting_pitcher: false)
    end
    let(:relief_pitcher) do
      Fabricate(:player, defense1: 0, bar1: 2, primary_position: 1,
                         pitcher_type: "R", throws: "L", pitcher_rating: 80,
                         hitting_pitcher: false)
    end

    context "when no players" do
      it "returns []" do
        expect(Player.starting_pitchers).to eq([])
      end
    end

    context "when pitchers" do
      before do
        first_base
        starting_pitcher
        relief_pitcher
      end

      it "returns pitcher" do
        expect(Player.starting_pitchers).to eq([starting_pitcher])
      end
    end
  end

  describe ".relief_pitchers" do
    let(:first_base) do
      Fabricate(:player, defense3: 1, defense7: -1, primary_position: 3,
                         offensive_rating: 80)
    end
    let(:starting_pitcher) do
      Fabricate(:player, defense1: 0, bar1: 2, primary_position: 1,
                         pitcher_type: "S", throws: "R", pitcher_rating: 70,
                         hitting_pitcher: false)
    end
    let(:relief_pitcher) do
      Fabricate(:player, defense1: 0, bar1: 2, primary_position: 1,
                         pitcher_type: "R", throws: "L", pitcher_rating: 80,
                         hitting_pitcher: false)
    end

    context "when no players" do
      it "returns []" do
        expect(Player.relief_pitchers).to eq([])
      end
    end

    context "when pitchers" do
      before do
        first_base
        starting_pitcher
        relief_pitcher
      end

      it "returns pitcher" do
        expect(Player.relief_pitchers).to eq([relief_pitcher])
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

    describe "when bats filter" do
      let!(:left_player) { Fabricate(:player, bats: "L") }
      let!(:right_player) { Fabricate(:player, bats: "R") }
      let!(:switch_player) { Fabricate(:player, bats: "B") }

      context "is blank" do
        it "returns L, R, B" do
          expect(Player.filter_by)
            .to contain_exactly(left_player, right_player, switch_player)
        end
      end

      context "is 'L'" do
        it "returns L" do
          expect(Player.filter_by(bats: "L")).to eq([left_player])
        end
      end

      context "is 'R'" do
        it "returns R" do
          expect(Player.filter_by(bats: "R")).to eq([right_player])
        end
      end

      context "is 'B'" do
        it "returns B" do
          expect(Player.filter_by(bats: "B")).to eq([switch_player])
        end
      end

      context "is 'all'" do
        it "returns L, R, B" do
          expect(Player.filter_by(bats: "all"))
            .to contain_exactly(left_player, right_player, switch_player)
        end
      end
    end

    describe "when bunt_grade filter" do
      let!(:a_player) { Fabricate(:player, bunt_grade: "A") }
      let!(:b_player) { Fabricate(:player, bunt_grade: "B") }

      context "is blank" do
        it "returns A & B players" do
          expect(Player.filter_by).to contain_exactly(a_player, b_player)
        end
      end

      context "is 'A'" do
        it "returns A players" do
          expect(Player.filter_by(bunt_grade: "A")).to eq([a_player])
        end
      end

      context "is 'B'" do
        it "returns all" do
          expect(Player.filter_by(bunt_grade: "B"))
            .to contain_exactly(a_player, b_player)
        end
      end

      context "is 'all'" do
        it "returns A & B players" do
          expect(Player.filter_by(bunt_grade: "all"))
            .to contain_exactly(a_player, b_player)
        end
      end
    end

    describe "when speed filter" do
      let!(:player1) { Fabricate(:player, speed: 1) }
      let!(:player2) { Fabricate(:player, speed: 2) }
      let!(:player3) { Fabricate(:player, speed: 3) }
      let!(:player4) { Fabricate(:player, speed: 4) }
      let!(:player5) { Fabricate(:player, speed: 5) }
      let!(:player6) { Fabricate(:player, speed: 6) }

      context "is blank" do
        it "returns all players" do
          expect(Player.filter_by)
            .to contain_exactly(player1, player2, player3, player4, player5,
                                player6)
        end
      end

      context "is '2'" do
        it "returns players faster than 2" do
          expect(Player.filter_by(speed: "2"))
            .to contain_exactly(player3, player4, player5, player6)
        end
      end

      context "is '3'" do
        it "returns players faster than 3" do
          expect(Player.filter_by(speed: "3"))
            .to contain_exactly(player4, player5, player6)
        end
      end

      context "is '4'" do
        it "returns players faster than 4" do
          expect(Player.filter_by(speed: "4"))
            .to contain_exactly(player5, player6)
        end
      end

      context "is '5'" do
        it "returns players faster than 5" do
          expect(Player.filter_by(speed: "5")).to eq([player6])
        end
      end

      context "is '6'" do
        it "returns players faster than 6" do
          expect(Player.filter_by(speed: "6")).to eq([])
        end
      end

      context "is 'all'" do
        it "returns A & B players" do
          expect(Player.filter_by(speed: "all"))
            .to contain_exactly(player1, player2, player3, player4, player5,
                                player6)
        end
      end
    end

    describe "when throws filter" do
      let!(:left_player) { Fabricate(:player, throws: "L", bats: "R") }
      let!(:right_player) { Fabricate(:player, throws: "R", bats: "B") }

      context "is blank" do
        it "returns L & R Players" do
          expect(Player.filter_by).to contain_exactly(left_player, right_player)
        end
      end

      context "is 'L'" do
        it "returns L" do
          expect(Player.filter_by(throws: "L")).to eq([left_player])
        end
      end

      context "is 'R'" do
        it "returns R" do
          expect(Player.filter_by(throws: "R")).to eq([right_player])
        end
      end

      context "is 'all'" do
        it "returns L, R, B" do
          expect(Player.filter_by(throws: "all"))
            .to contain_exactly(left_player, right_player)
        end
      end
    end

    describe "when pitcher_type filter" do
      let!(:starter_player) { Fabricate(:player, pitcher_type: "S") }
      let!(:reliever_player) { Fabricate(:player, pitcher_type: "R") }

      context "is blank" do
        it "returns S & R Players" do
          expect(Player.filter_by)
            .to contain_exactly(starter_player, reliever_player)
        end
      end

      context "is 'L'" do
        it "returns L" do
          expect(Player.filter_by(pitcher_type: "S")).to eq([starter_player])
        end
      end

      context "is 'R'" do
        it "returns R" do
          expect(Player.filter_by(pitcher_type: "R")).to eq([reliever_player])
        end
      end

      context "is 'all'" do
        it "returns L, R, B" do
          expect(Player.filter_by(pitcher_type: "all"))
            .to contain_exactly(starter_player, reliever_player)
        end
      end
    end

    describe "when order filter" do
      context "is blank" do
        let!(:first_player) do
          Fabricate(:player, first_name: "Bob", last_name: "Beta",
                             offensive_rating: 90, pitcher_rating: 90)
        end
        let!(:second_player) do
          Fabricate(:player, first_name: "Bob", last_name: "Alpha",
                             offensive_rating: 85, pitcher_rating: 85)
        end

        it "orders by last_name" do
          expect(Player.filter_by).to eq([second_player, first_player])
        end
      end

      context "is 'name'" do
        let!(:first_player) do
          Fabricate(:player, first_name: "Beta", last_name: "Alpha",
                             offensive_rating: 90, pitcher_rating: 90)
        end
        let!(:second_player) do
          Fabricate(:player, first_name: "Alpha", last_name: "Alpha",
                             offensive_rating: 85, pitcher_rating: 85)
        end

        it "orders by last_name, first_name" do
          expect(Player.filter_by(order: "name"))
            .to eq([second_player, first_player])
        end
      end

      context "is 'offense'" do
        let!(:first_player) do
          Fabricate(:player, first_name: "Beta", last_name: "Alpha",
                             offensive_rating: 90, pitcher_rating: 90)
        end
        let!(:second_player) do
          Fabricate(:player, first_name: "Alpha", last_name: "Alpha",
                             offensive_rating: 95, pitcher_rating: 85)
        end

        it "orders by offensive_rating" do
          expect(Player.filter_by(order: "offense"))
            .to eq([second_player, first_player])
        end
      end

      context "is 'pitching'" do
        let!(:first_player) do
          Fabricate(:player, first_name: "Beta", last_name: "Alpha",
                             offensive_rating: 90, pitcher_rating: 90)
        end
        let!(:second_player) do
          Fabricate(:player, first_name: "Alpha", last_name: "Alpha",
                             offensive_rating: 85, pitcher_rating: 95)
        end

        it "orders by pitcher_rating" do
          expect(Player.filter_by(order: "pitching"))
            .to eq([second_player, first_player])
        end
      end

      context "is something else" do
        let!(:first_player) do
          Fabricate(:player, first_name: "Bob", last_name: "Beta",
                             offensive_rating: 90, pitcher_rating: 90)
        end
        let!(:second_player) do
          Fabricate(:player, first_name: "Bob", last_name: "Alpha",
                             offensive_rating: 85, pitcher_rating: 85)
        end

        it "orders by last_name" do
          expect(Player.filter_by(order: "something else"))
            .to eq([second_player, first_player])
        end
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
    let(:player) { Fabricate.build(:player) }

    before { player.roster_name = nil }

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

      context "and pitcher_type is nil" do
        before { subject.pitcher_type = nil }

        context "and hitting_pitcher is false" do
          before { subject.hitting_pitcher = false }

          it "returns 'P'" do
            expect(subject.primary_position_initials).to eq("P")
          end
        end

        context "and hitting_pitcher is true" do
          before { subject.hitting_pitcher = true }

          it "returns 'P+H'" do
            expect(subject.primary_position_initials).to eq("P+H")
          end
        end
      end

      context "and pitcher_type is 'S'" do
        before { subject.pitcher_type = "S" }

        context "and hitting_pitcher is false" do
          before { subject.hitting_pitcher = false }

          it "returns 'SP'" do
            expect(subject.primary_position_initials).to eq("SP")
          end
        end

        context "and hitting_pitcher is true" do
          before { subject.hitting_pitcher = true }

          it "returns 'SP+H'" do
            expect(subject.primary_position_initials).to eq("SP+H")
          end
        end
      end

      context "and pitcher_type is 'R'" do
        before { subject.pitcher_type = "R" }

        context "and hitting_pitcher is false" do
          before { subject.hitting_pitcher = false }

          it "returns 'RP'" do
            expect(subject.primary_position_initials).to eq("RP")
          end
        end

        context "and hitting_pitcher is true" do
          before { subject.hitting_pitcher = true }

          it "returns 'RP+H'" do
            expect(subject.primary_position_initials).to eq("RP+H")
          end
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

  describe "#position_bar" do
    let(:player) do
      Fabricate(:player, primary_position: 2, defense2: 1, bar2: 2, bar1: 3,
                         defense3: 4)
    end

    context "for position 1" do
      it "returns their bar1" do
        expect(player.position_bar(1)).to eq(3)
      end
    end

    context "for position 2" do
      it "returns their bar2" do
        expect(player.position_bar(2)).to eq(2)
      end
    end

    context "for position 3" do
      it "returns nil" do
        expect(player.position_bar(3)).to be_nil
      end
    end
  end

  describe "#verbose_pitcher_type" do
    context "when pitcher_type is nil" do
      before { subject.pitcher_type = nil }

      it "returns nil" do
        expect(subject.verbose_pitcher_type).to eq(nil)
      end
    end

    context "when pitcher_type is 'S'" do
      before { subject.pitcher_type = "S" }

      it "returns nil" do
        expect(subject.verbose_pitcher_type).to eq("Starter")
      end
    end

    context "when pitcher_type is 'R'" do
      before { subject.pitcher_type = "R" }

      it "returns nil" do
        expect(subject.verbose_pitcher_type).to eq("Reliever")
      end
    end

    context "when pitcher_type is something else" do
      before { subject.pitcher_type = "something else" }

      it "returns nil" do
        expect(subject.verbose_pitcher_type).to eq(nil)
      end
    end
  end

  describe "#verbose_throws" do
    context "when throws is nil" do
      before { subject.throws = nil }

      it "returns nil" do
        expect(subject.verbose_throws).to eq(nil)
      end
    end

    context "when throws is 'L'" do
      before { subject.throws = "L" }

      it "returns nil" do
        expect(subject.verbose_throws).to eq("Left")
      end
    end

    context "when throws is 'R'" do
      before { subject.throws = "R" }

      it "returns nil" do
        expect(subject.verbose_throws).to eq("Right")
      end
    end

    context "when throws is something else" do
      before { subject.throws = "something else" }

      it "returns nil" do
        expect(subject.verbose_throws).to eq(nil)
      end
    end
  end

  describe "#verbose_bats" do
    context "when bats is nil" do
      before { subject.bats = nil }

      it "returns nil" do
        expect(subject.verbose_bats).to eq(nil)
      end
    end

    context "when bats is 'L'" do
      before { subject.bats = "L" }

      it "returns Left" do
        expect(subject.verbose_bats).to eq("Left")
      end
    end

    context "when bats is 'R'" do
      before { subject.bats = "R" }

      it "returns Right" do
        expect(subject.verbose_bats).to eq("Right")
      end
    end

    context "when bats is 'B'" do
      before { subject.bats = "B" }

      it "returns Switch" do
        expect(subject.verbose_bats).to eq("Switch")
      end
    end

    context "when bats is something else" do
      before { subject.bats = "something else" }

      it "returns nil" do
        expect(subject.verbose_throws).to eq(nil)
      end
    end
  end

  describe "#starting_pitcher?" do
    context "for a relief pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.relief_pitching = 67
      end

      it "returns false" do
        expect(subject.starting_pitcher?).to eq(false)
      end
    end

    context "for a starting pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.starting_pitching = 67
      end

      it "returns true" do
        expect(subject.starting_pitcher?).to eq(true)
      end
    end

    context "for a shortstop" do
      before do
        subject.primary_position = 6
        subject.defense6 = 9
      end

      it "returns false" do
        expect(subject.starting_pitcher?).to eq(false)
      end
    end
  end

  describe "#relief_pitcher?" do
    context "for a relief pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.relief_pitching = 67
      end

      it "returns true" do
        expect(subject.relief_pitcher?).to eq(true)
      end
    end

    context "for a starting pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.starting_pitching = 67
      end

      it "returns false" do
        expect(subject.relief_pitcher?).to eq(false)
      end
    end

    context "for a shortstop" do
      before do
        subject.primary_position = 6
        subject.defense6 = 9
      end

      it "returns false" do
        expect(subject.relief_pitcher?).to eq(false)
      end
    end
  end

  describe "#infielder?" do
    context "for a pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.starting_pitching = 67
      end

      it "returns false" do
        expect(subject.infielder?).to eq(false)
      end
    end

    context "for a shortstop" do
      before do
        subject.primary_position = 6
        subject.defense6 = 9
      end

      it "returns true" do
        expect(subject.infielder?).to eq(true)
      end
    end

    context "for a center fielder" do
      before do
        subject.primary_position = 8
        subject.defense8 = 9
      end

      it "returns false" do
        expect(subject.infielder?).to eq(false)
      end
    end
  end

  describe "#outfielder?" do
    context "for a pitcher" do
      before do
        subject.primary_position = 1
        subject.defense1 = 4
        subject.starting_pitching = 67
      end

      it "returns false" do
        expect(subject.outfielder?).to eq(false)
      end
    end

    context "for a shortstop" do
      before do
        subject.primary_position = 6
        subject.defense6 = 9
      end

      it "returns false" do
        expect(subject.outfielder?).to eq(false)
      end
    end

    context "for a center fielder" do
      before do
        subject.primary_position = 8
        subject.defense8 = 9
      end

      it "returns true" do
        expect(subject.outfielder?).to eq(true)
      end
    end
  end

  describe "#plays_position?" do
    context "when position is nil" do
      let(:player) { Fabricate(:hitter) }

      it "returns false" do
        expect(player.plays_position?(nil)).to eq(false)
      end
    end

    context "for a pitcher" do
      let(:player) { Fabricate(:pitcher) }

      context "when position 1" do
        it "returns true" do
          expect(player.plays_position?(1)).to eq(true)
        end
      end

      context "when position 2" do
        it "returns false" do
          expect(player.plays_position?(2)).to eq(false)
        end
      end

      context "when position 3" do
        it "returns false" do
          expect(player.plays_position?(3)).to eq(false)
        end
      end

      context "when position 4" do
        it "returns false" do
          expect(player.plays_position?(4)).to eq(false)
        end
      end

      context "when position 5" do
        it "returns false" do
          expect(player.plays_position?(5)).to eq(false)
        end
      end

      context "when position 6" do
        it "returns false" do
          expect(player.plays_position?(6)).to eq(false)
        end
      end

      context "when position 7" do
        it "returns false" do
          expect(player.plays_position?(7)).to eq(false)
        end
      end

      context "when position 8" do
        it "returns false" do
          expect(player.plays_position?(8)).to eq(false)
        end
      end

      context "when position 9" do
        it "returns true" do
          expect(player.plays_position?(9)).to eq(true)
        end
      end

      context "when position 10" do
        it "returns false" do
          expect(player.plays_position?(10)).to eq(false)
        end
      end
    end

    context "for a catcher/first base" do
      let(:player) { Fabricate(:hitter, primary_position: 2, defense3: -1) }

      context "when position 1" do
        it "returns false" do
          expect(player.plays_position?(1)).to eq(false)
        end
      end

      context "when position 2" do
        it "returns true" do
          expect(player.plays_position?(2)).to eq(true)
        end
      end

      context "when position 3" do
        it "returns true" do
          expect(player.plays_position?(3)).to eq(true)
        end
      end

      context "when position 4" do
        it "returns false" do
          expect(player.plays_position?(4)).to eq(false)
        end
      end

      context "when position 5" do
        it "returns false" do
          expect(player.plays_position?(5)).to eq(false)
        end
      end

      context "when position 6" do
        it "returns false" do
          expect(player.plays_position?(6)).to eq(false)
        end
      end

      context "when position 7" do
        it "returns false" do
          expect(player.plays_position?(7)).to eq(false)
        end
      end

      context "when position 8" do
        it "returns false" do
          expect(player.plays_position?(8)).to eq(false)
        end
      end

      context "when position 9" do
        it "returns true" do
          expect(player.plays_position?(9)).to eq(true)
        end
      end

      context "when position 10" do
        it "returns false" do
          expect(player.plays_position?(10)).to eq(false)
        end
      end
    end

    context "for a infielder" do
      let(:player) { Fabricate(:hitter, primary_position: 4, defense6: 0) }

      context "when position 1" do
        it "returns false" do
          expect(player.plays_position?(1)).to eq(false)
        end
      end

      context "when position 2" do
        it "returns false" do
          expect(player.plays_position?(2)).to eq(false)
        end
      end

      context "when position 3" do
        it "returns false" do
          expect(player.plays_position?(3)).to eq(false)
        end
      end

      context "when position 4" do
        it "returns true" do
          expect(player.plays_position?(4)).to eq(true)
        end
      end

      context "when position 5" do
        it "returns false" do
          expect(player.plays_position?(5)).to eq(false)
        end
      end

      context "when position 6" do
        it "returns true" do
          expect(player.plays_position?(6)).to eq(true)
        end
      end

      context "when position 7" do
        it "returns false" do
          expect(player.plays_position?(7)).to eq(false)
        end
      end

      context "when position 8" do
        it "returns false" do
          expect(player.plays_position?(8)).to eq(false)
        end
      end

      context "when position 9" do
        it "returns true" do
          expect(player.plays_position?(9)).to eq(true)
        end
      end
    end

    context "for a center fielder" do
      let(:player) { Fabricate(:hitter, primary_position: 8) }

      context "when position 1" do
        it "returns false" do
          expect(player.plays_position?(1)).to eq(false)
        end
      end

      context "when position 2" do
        it "returns false" do
          expect(player.plays_position?(2)).to eq(false)
        end
      end

      context "when position 3" do
        it "returns false" do
          expect(player.plays_position?(3)).to eq(false)
        end
      end

      context "when position 4" do
        it "returns false" do
          expect(player.plays_position?(4)).to eq(false)
        end
      end

      context "when position 5" do
        it "returns false" do
          expect(player.plays_position?(5)).to eq(false)
        end
      end

      context "when position 6" do
        it "returns false" do
          expect(player.plays_position?(6)).to eq(false)
        end
      end

      context "when position 7" do
        it "returns false" do
          expect(player.plays_position?(7)).to eq(false)
        end
      end

      context "when position 8" do
        it "returns true" do
          expect(player.plays_position?(8)).to eq(true)
        end
      end

      context "when position 9" do
        it "returns true" do
          expect(player.plays_position?(9)).to eq(true)
        end
      end
    end
  end

  describe "#roster_level" do
    let(:player) { Fabricate(:player, primary_position: 5) }

    context "when no roster" do
      it "returns nil" do
        expect(player.roster_level).to eq(nil)
      end
    end

    context "when roster level is 1" do
      before { Fabricate(:roster, player: player, level: 1, position: 3) }

      it "returns A" do
        expect(player.roster_level).to eq("A")
      end
    end

    context "when roster level is 2" do
      before { Fabricate(:roster, player: player, level: 2, position: 3) }

      it "returns A" do
        expect(player.roster_level).to eq("AA")
      end
    end

    context "when roster level is 3" do
      before { Fabricate(:roster, player: player, level: 3, position: 3) }

      it "returns A" do
        expect(player.roster_level).to eq("AAA")
      end
    end

    context "when roster level is 4" do
      before { Fabricate(:roster, player: player, level: 4, position: 5) }

      it "returns A" do
        expect(player.roster_level).to eq("Majors")
      end
    end
  end
end
