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
      .scoped_to(%i[team_id vs with_dh away]).case_insensitive
  end

  it do
    is_expected.to validate_inclusion_of(:vs).in_array([nil, "left", "right"])
  end

  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:spots) }
  it { is_expected.to have_many(:players) }

  describe ".after_update" do
    describe "#fix_dh_spot" do
      context "when lineup with_dh is true" do
        let(:lineup) { Fabricate(:lineup, with_dh: true) }

        before do
          Fabricate(:spot, lineup:, batting_order: 1, position: 2)
          Fabricate(:spot, lineup:, batting_order: 2, position: 9)
        end

        context "and with_dh doesn't change" do
          it "doesn't change spots count" do
            expect do
              lineup.update(name: "New")
            end.not_to change(lineup.spots, :count)
          end
        end

        context "and with_dh changes to false" do
          it "removes DH spot" do
            expect do
              lineup.update(with_dh: false)
            end.to change(lineup.spots.where(position: 9), :count).by(-1)
          end
        end
      end

      context "when lineup with_dh is false" do
        let(:lineup) { Fabricate(:lineup, with_dh: false) }

        before do
          Fabricate(:spot, lineup:, batting_order: 1, position: 2)
          Fabricate(:spot, lineup:, batting_order: 2, position: 9)
        end

        context "and with_dh doesn't change" do
          it "removes DH spot" do
            expect do
              lineup.update(name: "New")
            end.to change(lineup.spots.where(position: 9), :count).by(-1)
          end
        end
      end
    end

    describe "#fix_pitcher_spot" do
      context "when lineup with_dh is false" do
        let(:lineup) { Fabricate(:lineup, with_dh: false) }

        before do
          Fabricate(:spot, lineup:, batting_order: 1, position: 2)
        end

        context "and with_dh doesn't change" do
          context "when pitcher batting 9th" do
            it "doesn't change spots count" do
              expect do
                lineup.update(name: "New")
              end.not_to change(lineup.spots, :count)
            end
          end

          context "when hitter batting 9th" do
            before do
              pitcher_spot = lineup.spots.find_by(position: 1)
              pitcher_spot.update batting_order: 8
              Fabricate(:spot, lineup:, batting_order: 9, position: 3)
            end

            it "doesn't change spots count" do
              expect do
                lineup.update(name: "New")
              end.not_to change(lineup.spots, :count)
            end
          end
        end

        context "and with_dh changes to true" do
          it "removes pitcher spot" do
            expect do
              lineup.update(with_dh: true)
            end.to change(lineup.spots.where(position: 1), :count).by(-1)
          end
        end
      end

      context "when lineup with_dh is true" do
        let(:lineup) { Fabricate(:lineup, with_dh: true) }

        before do
          Fabricate(:spot, lineup:, batting_order: 1, position: 2)
        end

        context "and with_dh doesn't change" do
          it "doesn't change spots count" do
            expect do
              lineup.update(name: "New")
            end.not_to change(lineup.spots, :count)
          end
        end

        context "and with_dh changes to false" do
          context "and no ninth batter" do
            it "adds pitcher spot" do
              expect do
                lineup.update(with_dh: false)
              end.to change(lineup.spots.where(position: 1), :count).by(1)
            end

            it "removes 9th batting_order spot" do
              expect do
                lineup.update(with_dh: false)
              end.to change(lineup.spots.where(batting_order: 9), :count).by(1)
            end
          end

          context "and ninth batter" do
            before do
              Fabricate(:spot, lineup:, batting_order: 9, position: 5)
            end

            it "adds pitcher spot" do
              expect do
                lineup.update(with_dh: false)
              end.to change(lineup.spots.where(position: 1), :count).by(1)
            end

            it "removes 9th batting_order spot" do
              expect do
                lineup.update(with_dh: false)
              end.to change(lineup.spots.where(batting_order: 9), :count).by(0)
            end
          end
        end
      end
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
    context "when name and vs are blank" do
      context "and with_dh and away are default" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = false
          subject.away = true
        end

        it "returns nil" do
          expect(subject.full_name).to eq("Away Lineup")
        end
      end

      context "and with_dh is false, away is false" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = false
          subject.away = false
        end

        it "returns nil" do
          expect(subject.full_name).to eq("Home Lineup")
        end
      end

      context "and with_dh is true, away is true" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = true
          subject.away = true
        end

        it "returns nil" do
          expect(subject.full_name).to eq("Away Lineup (DH)")
        end
      end

      context "and with_dh is true, away is false" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = true
          subject.away = false
        end

        it "returns nil" do
          expect(subject.full_name).to eq("Home Lineup (DH)")
        end
      end
    end

    context "when name is something" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = false
        subject.away = true
      end

      it "returns name only" do
        expect(subject.full_name).to eq("Something Away Lineup")
      end
    end

    context "when name is something with DH" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = true
      end

      it "returns name and DH" do
        expect(subject.full_name).to eq("Something Away Lineup (DH)")
      end
    end

    context "when vs is something" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns 'Lineup vs Lefty'" do
        expect(subject.full_name).to eq("Away Lineup vs Lefty")
      end
    end

    context "when vs is something with DH" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns 'Lineup vs Lefty (DH)'" do
        expect(subject.full_name).to eq("Away Lineup vs Lefty (DH)")
      end
    end

    context "when name is something and vs is left" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.full_name).to eq("Main Away Lineup vs Lefty")
      end
    end

    context "when name is something and vs is right" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.full_name).to eq("Main Away Lineup vs Righty")
      end
    end

    context "when name is something and vs is left with DH" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns name, vs, DH" do
        expect(subject.full_name).to eq("Main Away Lineup vs Lefty (DH)")
      end
    end

    context "when name is something and vs is right with DH" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = true
      end

      it "returns name, vs, DH" do
        expect(subject.full_name).to eq("Main Away Lineup vs Righty (DH)")
      end
    end
  end

  describe "#short_name" do
    context "when name and vs are blank" do
      context "and with_dh and away are default" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = false
          subject.away = true
        end

        it "returns nil" do
          expect(subject.short_name).to eq("Away")
        end
      end

      context "and with_dh is false and away is false" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = false
          subject.away = false
        end

        it "returns nil" do
          expect(subject.short_name).to eq("Home")
        end
      end

      context "and with_dh is true and away is true" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = true
          subject.away = true
        end

        it "returns nil" do
          expect(subject.short_name).to eq("Away (DH)")
        end
      end

      context "and with_dh is true and away is false" do
        before do
          subject.name = ""
          subject.vs = ""
          subject.with_dh = true
          subject.away = false
        end

        it "returns nil" do
          expect(subject.short_name).to eq("Home (DH)")
        end
      end
    end

    context "when name is something" do
      context "and with_dh is false, away is true" do
        before do
          subject.name = "Something"
          subject.vs = ""
          subject.with_dh = false
          subject.away = true
        end

        it "returns name only" do
          expect(subject.short_name).to eq("Something Away")
        end
      end

      context "and with_dh is false, away is false" do
        before do
          subject.name = "Something"
          subject.vs = ""
          subject.with_dh = false
          subject.away = false
        end

        it "returns name only" do
          expect(subject.short_name).to eq("Something Home")
        end
      end
    end

    context "when name is something with DH" do
      before do
        subject.name = "Something"
        subject.vs = ""
        subject.with_dh = true
      end

      it "returns name and DH" do
        expect(subject.short_name).to eq("Something Away (DH)")
      end
    end

    context "when vs is something" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns 'vs Lefty'" do
        expect(subject.short_name).to eq("Away vs Lefty")
      end
    end

    context "when vs is something with DH" do
      before do
        subject.name = ""
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns 'vs Lefty (DH)'" do
        expect(subject.short_name).to eq("Away vs Lefty (DH)")
      end
    end

    context "when name is something and vs is left" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.short_name).to eq("Main Away vs Lefty")
      end
    end

    context "when name is something and vs is right" do
      before do
        subject.name = "Main"
        subject.vs = "right"
        subject.with_dh = false
      end

      it "returns name and vs" do
        expect(subject.short_name).to eq("Main Away vs Righty")
      end
    end

    context "when name is something and vs is left with DH" do
      before do
        subject.name = "Main"
        subject.vs = "left"
        subject.with_dh = true
      end

      it "returns name, vs, DH" do
        expect(subject.short_name).to eq("Main Away vs Lefty (DH)")
      end
    end

    context "when name is something and vs is right with DH" do
      context "and away is true" do
        before do
          subject.name = "Main"
          subject.vs = "right"
          subject.with_dh = true
        end

        it "returns name, vs, DH" do
          expect(subject.short_name).to eq("Main Away vs Righty (DH)")
        end
      end

      context "and away is false" do
        before do
          subject.name = "Main"
          subject.vs = "right"
          subject.with_dh = true
          subject.away = false
        end

        it "returns name, vs, DH" do
          expect(subject.short_name).to eq("Main Home vs Righty (DH)")
        end
      end
    end
  end

  describe "#remove_dh_spot" do
    let(:lineup) { Fabricate(:dh_lineup) }

    before { Fabricate(:spot, lineup:, batting_order: 2, position: 2) }

    context "when the dh spot and 9th batting order are empty" do
      it "doesn't destroy any spots" do
        expect do
          lineup.remove_dh_spot
        end.not_to change(lineup.spots, :count)
      end
    end

    context "when the dh spot taken" do
      before { Fabricate(:spot, lineup:, batting_order: 3, position: 9) }

      it "destroys the spot" do
        expect do
          lineup.remove_dh_spot
        end.to change(lineup.spots, :count).by(-1)
      end
    end

    context "when 9th batting_order taken" do
      before { Fabricate(:spot, lineup:, batting_order: 9, position: 7) }

      it "doesn't destroy the spot" do
        expect do
          lineup.remove_dh_spot
        end.not_to change(lineup.spots, :count)
      end
    end

    context "when dh is batting 9th" do
      before { Fabricate(:spot, lineup:, batting_order: 9, position: 9) }

      it "destroys the spot" do
        expect do
          lineup.remove_dh_spot
        end.to change(lineup.spots, :count).by(-1)
      end
    end
  end

  describe "#bench" do
    let(:lineup) { Fabricate(:lineup, team:) }

    context "when no players" do
      it "returns []" do
        expect(lineup.bench).to eq([])
      end
    end

    context "when team has 3 players" do
      let(:first_player) do
        Fabricate(:hitter, primary_position: 2, defense2: 2)
      end
      let(:second_player) do
        Fabricate(:hitter, primary_position: 3, defense3: 5)
      end
      let(:third_player) do
        Fabricate(:hitter, primary_position: 5, defense5: 5)
      end

      before do
        Fabricate(:contract, team:, player: first_player)
        Fabricate(:contract, team:, player: second_player)
        Fabricate(:contract, team:, player: third_player)
        Fabricate(:contract)

        Fabricate(:roster, team:, player: first_player, level: 4,
                           position: 2)
        Fabricate(:roster, team:, player: second_player, level: 3,
                           position: 3)
      end

      context "and none in the lineup" do
        it "returns players with level 4 roster" do
          expect(lineup.bench).to eq([first_player])
        end
      end

      context "and one in the lineup" do
        before do
          Fabricate(:spot, player: first_player, lineup:, position: 2)
        end

        it "returns none" do
          expect(lineup.bench).to eq([])
        end
      end
    end
  end

  describe "#spots_at_position" do
    let(:lineup) { Fabricate(:lineup) }

    context "when no spots" do
      before { Fabricate(:spot, position: 2) }

      it "returns []" do
        expect(lineup.spots_at_position(2)).to eq([])
      end
    end

    context "when spot with position 2" do
      it "returns it" do
        spot = Fabricate(:spot, lineup:, position: 2)

        expect(lineup.spots_at_position(2)).to eq([spot])
      end
    end

    context "when given spot id" do
      it "returns []" do
        spot = Fabricate(:spot, lineup:, position: 2)

        expect(lineup.spots_at_position(2, spot.id)).to eq([])
      end
    end
  end

  describe "#complete?" do
    context "when no DH" do
      let(:lineup) { Fabricate(:lineup, with_dh: false) }

      context "and no spots" do
        it "returns false" do
          expect(lineup.complete?).to eq(false)
        end
      end

      context "and 8 spots" do
        before do
          (2..8).each do |batting_order|
            Fabricate(:spot, lineup:, batting_order:,
                             position: (batting_order + 1))
          end
        end

        it "returns false" do
          expect(lineup.complete?).to eq(false)
        end
      end

      context "and 8 spots and a pitcher" do
        before do
          (1..7).each do |batting_order|
            Fabricate(:spot, lineup:, batting_order:,
                             position: (batting_order + 1))
          end
          Fabricate(:spot, lineup:, batting_order: 8, position: 7)
        end

        it "returns true" do
          expect(lineup.complete?).to eq(true)
        end
      end
    end

    context "when DH" do
      let(:lineup) { Fabricate(:lineup, with_dh: true) }

      context "and no spots" do
        it "returns false" do
          expect(lineup.complete?).to eq(false)
        end
      end

      context "and 8 spots" do
        before do
          (1..8).each do |batting_order|
            Fabricate(:spot, lineup:, batting_order:,
                             position: (batting_order + 1))
          end
        end

        it "returns false" do
          expect(lineup.complete?).to eq(false)
        end
      end

      context "and 9 spots" do
        before do
          (1..8).each do |batting_order|
            Fabricate(:spot, lineup:, batting_order:,
                             position: (batting_order + 1))
          end
          Fabricate(:spot, lineup:, batting_order: 9, position: 7)
        end

        it "returns true" do
          expect(lineup.complete?).to eq(true)
        end
      end
    end
  end

  describe "#defense" do
    context "when no spots" do
      context "for away" do
        let(:lineup) { Fabricate(:lineup, away: true) }

        it "returns 0" do
          expect(lineup.defense).to eq(0)
        end
      end

      context "for home" do
        let(:lineup) { Fabricate(:lineup, away: false) }

        it "returns 6" do
          expect(lineup.defense).to eq(6)
        end
      end
    end

    context "when 2 valid spots" do
      context "for away" do
        let(:lineup) { Fabricate(:lineup, team:, away: true) }
        let(:second_base_player) do
          Fabricate(:player, primary_position: 4, defense4: 5)
        end
        let(:third_base_player) do
          Fabricate(:player, primary_position: 5, defense5: -1)
        end

        before do
          Fabricate(:contract, player: second_base_player, team:)
          Fabricate(:contract, player: third_base_player, team:)
          Fabricate(:roster, player: second_base_player, team:, level: 4,
                             position: 4)
          Fabricate(:roster, player: third_base_player, team:, level: 4,
                             position: 5)
          Fabricate(:spot, lineup:, batting_order: 2, position: 4,
                           player: second_base_player)
          Fabricate(:spot, lineup:, batting_order: 3, position: 5,
                           player: third_base_player)
        end

        it "returns a sum of their defenses" do
          expect(lineup.defense).to eq(4)
        end
      end

      context "for home" do
        let(:lineup) { Fabricate(:lineup, team:, away: false) }
        let(:second_base_player) do
          Fabricate(:player, primary_position: 4, defense4: 5)
        end
        let(:third_base_player) do
          Fabricate(:player, primary_position: 5, defense5: -1)
        end

        before do
          Fabricate(:contract, player: second_base_player, team:)
          Fabricate(:contract, player: third_base_player, team:)
          Fabricate(:roster, player: second_base_player, team:, level: 4,
                             position: 4)
          Fabricate(:roster, player: third_base_player, team:, level: 4,
                             position: 5)
          Fabricate(:spot, lineup:, batting_order: 2, position: 4,
                           player: second_base_player)
          Fabricate(:spot, lineup:, batting_order: 3, position: 5,
                           player: third_base_player)
        end

        it "returns a sum of their defenses" do
          expect(lineup.defense).to eq(10)
        end
      end
    end

    context "when a spot is missing defense" do
      context "for away" do
        let(:lineup) { Fabricate(:lineup, team:, away: true) }
        let(:second_base_player) do
          Fabricate(:player, primary_position: 4, defense4: 5)
        end
        let(:third_base_player) do
          Fabricate(:player, primary_position: 5, defense5: -1)
        end

        before do
          Fabricate(:contract, player: second_base_player, team:)
          Fabricate(:contract, player: third_base_player, team:)
          Fabricate(:roster, player: second_base_player, team:, level: 4,
                             position: 4)
          Fabricate(:roster, player: third_base_player, team:, level: 4,
                             position: 5)
          Fabricate(:spot, lineup:, batting_order: 2, position: 4,
                           player: second_base_player)
          Fabricate(:spot, lineup:, batting_order: 3, position: 5,
                           player: third_base_player)
          third_base_player.update_column :defense5, nil
        end

        it "returns the valid defense" do
          expect(lineup.defense).to eq(-5)
        end
      end

      context "for home" do
        let(:lineup) { Fabricate(:lineup, team:, away: false) }
        let(:second_base_player) do
          Fabricate(:player, primary_position: 4, defense4: 5)
        end
        let(:third_base_player) do
          Fabricate(:player, primary_position: 5, defense5: -1)
        end

        before do
          Fabricate(:contract, player: second_base_player, team:)
          Fabricate(:contract, player: third_base_player, team:)
          Fabricate(:roster, player: second_base_player, team:, level: 4,
                             position: 4)
          Fabricate(:roster, player: third_base_player, team:, level: 4,
                             position: 5)
          Fabricate(:spot, lineup:, batting_order: 2, position: 4,
                           player: second_base_player)
          Fabricate(:spot, lineup:, batting_order: 3, position: 5,
                           player: third_base_player)
          third_base_player.update_column :defense5, nil
        end

        it "returns the valid defense" do
          expect(lineup.defense).to eq(1)
        end
      end
    end
  end

  describe "#catcher_bar" do
    let(:lineup) { Fabricate(:lineup, team:) }
    let(:player) do
      Fabricate(:player, primary_position: 2, defense2: 4, bar2: 2)
    end

    before do
      Fabricate(:contract, team:, player:)
      Fabricate(:roster, team:, player:, level: 4, position: 2)
    end

    context "when no catcher spot" do
      it "returns 0" do
        expect(lineup.catcher_bar).to eq(0)
      end
    end

    context "when catcher spot" do
      before { Fabricate(:spot, lineup:, player:, position: 2) }

      context "with a good catcher" do
        it "returns the player's catcher_bar" do
          expect(lineup.catcher_bar).to eq(2)
        end
      end

      context "with a bad catcher" do
        before { player.update(bar2: nil) }

        it "returns 0" do
          expect(lineup.catcher_bar).to eq(0)
        end
      end
    end
  end
end
