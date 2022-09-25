# frozen_string_literal: true

require "rails_helper"

RSpec.describe HittersImporter, type: :class do
  let(:first_team) { Fabricate(:team) }
  let(:second_team) { Fabricate(:team) }
  let(:file_path) { File.join(dir_path, "hitters.csv") }

  let(:header) do
    "Bats,Spd,Bunt,Player,Pos,Def,C-Bar,Rating,vs L,vs R,LOBP,LSLG,LHR,ROBP," \
      "RSLG,RHR,C,1B,2B,3B,SS,CF,OF,P,C-Bar,P-Bar,Roster Name,Durability," \
      "Contract"
  end

  let(:first_row) do
    "R,1,B,Johnny Bench,C,+ 14,3,76,72,60,65,79,83,58,63,61,+ 14,0,,- 3,,,0,," \
      "3,,Bench,84,"
  end

  let(:second_row) do
    "L,3,A,Turkey Stearnes,CF,+ 7,,79,70,79,66,74,65,76,82,64,,0,,,,+ 7,+ 5,," \
      "0,,Stearnes,92,"
  end

  before(:all) do
    FileUtils.mkdir_p(dir_path)
  end

  after(:each) { File.delete(file_path) }

  describe "#import" do
    let(:rows) { [header, first_row, second_row] }

    subject { described_class.new }

    context "when CSV has two new hitters" do
      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "creates two players" do
        expect do
          subject.import
        end.to change(Player, :count).by(2)
      end

      it "sets the first hitter's attributes" do
        subject.import

        player = Player.find_by!(roster_name: "Bench")
        expect(player.first_name).to eq("Johnny")
        expect(player.last_name).to eq("Bench")
        expect(player.nick_name).to be_nil
        expect(player.bats).to eq("R")
        expect(player.speed).to eq(1)
        expect(player.bunt_grade).to eq("B")
        expect(player.name).to eq("Johnny Bench")
        expect(player.primary_position).to eq(2)
        expect(player.bar1).to eq(0)
        expect(player.bar2).to eq(3)
        expect(player.offensive_rating).to eq(76)
        expect(player.left_hitting).to eq(72)
        expect(player.right_hitting).to eq(60)
        expect(player.left_on_base_percentage).to eq(65)
        expect(player.left_slugging).to eq(79)
        expect(player.left_homerun).to eq(83)
        expect(player.right_on_base_percentage).to eq(58)
        expect(player.right_slugging).to eq(63)
        expect(player.right_homerun).to eq(61)
        expect(player.defense1).to eq(0)
        expect(player.defense2).to eq(14)
        expect(player.defense3).to eq(0)
        expect(player.defense4).to eq(0)
        expect(player.defense5).to eq(-3)
        expect(player.defense6).to eq(0)
        expect(player.defense7).to eq(0)
        expect(player.defense8).to eq(0)
        expect(player.offensive_durability).to eq(84)
      end

      it "sets the second hitter's attributes" do
        subject.import

        player = Player.find_by!(roster_name: "Stearnes")
        expect(player.first_name).to eq("Turkey")
        expect(player.last_name).to eq("Stearnes")
        expect(player.nick_name).to be_nil
        expect(player.bats).to eq("L")
        expect(player.speed).to eq(3)
        expect(player.bunt_grade).to eq("A")
        expect(player.name).to eq("Turkey Stearnes")
        expect(player.primary_position).to eq(8)
        expect(player.bar1).to eq(0)
        expect(player.bar2).to eq(0)
        expect(player.offensive_rating).to eq(79)
        expect(player.left_hitting).to eq(70)
        expect(player.right_hitting).to eq(79)
        expect(player.left_on_base_percentage).to eq(66)
        expect(player.left_slugging).to eq(74)
        expect(player.left_homerun).to eq(65)
        expect(player.right_on_base_percentage).to eq(76)
        expect(player.right_slugging).to eq(82)
        expect(player.right_homerun).to eq(64)
        expect(player.defense1).to eq(0)
        expect(player.defense2).to eq(0)
        expect(player.defense3).to eq(0)
        expect(player.defense4).to eq(0)
        expect(player.defense5).to eq(0)
        expect(player.defense6).to eq(0)
        expect(player.defense7).to eq(5)
        expect(player.defense8).to eq(7)
        expect(player.offensive_durability).to eq(92)
      end
    end

    context "when CSV has one new hitter" do
      let!(:hitter) do
        Fabricate(:hitter, roster_name: "Bench", first_name: "Old")
      end

      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "creates one new player" do
        expect do
          subject.import
        end.to change(Player, :count).by(1)
      end

      it "updates the existing player's attributes" do
        expect do
          subject.import
          hitter.reload
        end.to change(hitter, :first_name).to("Johnny")
           .and change(hitter, :last_name).to("Bench")
      end

      it "sets the second hitter's attributes" do
        subject.import

        player = Player.find_by!(roster_name: "Stearnes")
        expect(player.bats).to eq("L")
        expect(player.speed).to eq(3)
        expect(player.bunt_grade).to eq("A")
        expect(player.name).to eq("Turkey Stearnes")
        expect(player.primary_position).to eq(8)
        expect(player.bar1).to eq(0)
        expect(player.bar2).to eq(0)
        expect(player.offensive_rating).to eq(79)
        expect(player.left_hitting).to eq(70)
        expect(player.right_hitting).to eq(79)
        expect(player.left_on_base_percentage).to eq(66)
        expect(player.left_slugging).to eq(74)
        expect(player.left_homerun).to eq(65)
        expect(player.right_on_base_percentage).to eq(76)
        expect(player.right_slugging).to eq(82)
        expect(player.right_homerun).to eq(64)
        expect(player.defense1).to eq(0)
        expect(player.defense2).to eq(0)
        expect(player.defense3).to eq(0)
        expect(player.defense4).to eq(0)
        expect(player.defense5).to eq(0)
        expect(player.defense6).to eq(0)
        expect(player.defense7).to eq(5)
        expect(player.defense8).to eq(7)
        expect(player.offensive_durability).to eq(92)
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
