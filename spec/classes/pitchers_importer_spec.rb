# frozen_string_literal: true

require "rails_helper"

RSpec.describe PitchersImporter, type: :class do
  let(:first_team) { Fabricate(:team) }
  let(:second_team) { Fabricate(:team) }
  let(:file_path) { File.join(dir_path, "pitchers.csv") }
  let!(:first_pitcher) { Fabricate(:hitter, roster_name: "Grove") }
  let!(:second_pitcher) { Fabricate(:hitter, roster_name: "M.Rivera") }

  let(:header) do
    "Pitcher,Type,Rating,Starter,Dur,Reliever,Def,Bar,Roster Name"
  end

  let(:first_row) do
    "Lefty Grove,LS,96,95,82,91,0,0,Grove"
  end

  let(:second_row) do
    "Mariano Rivera,RR,99,,34,98,+ 3,1,M.Rivera"
  end

  before(:all) do
    FileUtils.mkdir_p(dir_path)
  end

  after(:each) { File.delete(file_path) }

  describe "#import" do
    let(:rows) { [header, first_row, second_row] }

    subject { described_class.new }

    context "when CSV has two new pitchers" do
      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "doesn't create any new players" do
        expect do
          subject.import
        end.not_to change(Player, :count)
      end

      it "sets the first pitcher's attributes" do
        subject.import
        first_pitcher.reload

        expect(first_pitcher.first_name).to eq("Lefty")
        expect(first_pitcher.nick_name).to be_nil
        expect(first_pitcher.last_name).to eq("Grove")
        expect(first_pitcher.throws).to eq("L")
        expect(first_pitcher.pitcher_type).to eq("S")
        expect(first_pitcher.primary_position).to eq(1)
        expect(first_pitcher.pitcher_rating).to eq(96)
        expect(first_pitcher.starting_pitching).to eq(95)
        expect(first_pitcher.relief_pitching).to eq(91)
        expect(first_pitcher.pitching_durability).to eq(82)
        expect(first_pitcher.defense1).to eq(0)
        expect(first_pitcher.bar1).to eq(0)
      end

      it "sets the second pitcher's attributes" do
        subject.import
        second_pitcher.reload

        expect(second_pitcher.first_name).to eq("Mariano")
        expect(second_pitcher.nick_name).to be_nil
        expect(second_pitcher.last_name).to eq("Rivera")
        expect(second_pitcher.throws).to eq("R")
        expect(second_pitcher.pitcher_type).to eq("R")
        expect(second_pitcher.primary_position).to eq(1)
        expect(second_pitcher.pitcher_rating).to eq(99)
        expect(second_pitcher.starting_pitching).to be_nil
        expect(second_pitcher.relief_pitching).to eq(98)
        expect(second_pitcher.pitching_durability).to eq(34)
        expect(second_pitcher.defense1).to eq(3)
        expect(second_pitcher.bar1).to eq(1)
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
