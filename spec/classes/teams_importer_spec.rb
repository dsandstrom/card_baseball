# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeamsImporter, type: :class do
  let(:first_league) { Fabricate(:league) }
  let(:second_league) { Fabricate(:league) }

  let(:file_path) { File.join(dir_path, "teams.csv") }
  let(:header) { "Name,ID,League" }

  let(:first_row) do
    "Mudhens,MUD,#{first_league.name}"
  end

  let(:second_row) do
    "Gauchos,GCH,#{second_league.name}"
  end

  before(:all) do
    FileUtils.mkdir_p(dir_path)
  end

  after(:each) { File.delete(file_path) }

  describe "#import" do
    subject { described_class.new }

    context "when CSV has two new leagues" do
      let(:rows) { [header, first_row, second_row] }

      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "creates two teams" do
        expect do
          subject.import
        end.to change(Team, :count).by(2)
      end

      it "sets first team's attributes" do
        subject.import

        team = Team.find_by!(name: "Mudhens")
        expect(team.league_id).to eq(first_league.id)
        expect(team.identifier).to eq("MUD")
      end

      it "sets second team's attributes" do
        subject.import

        team = Team.find_by!(name: "Gauchos")
        expect(team.league_id).to eq(second_league.id)
        expect(team.identifier).to eq("GCH")
      end
    end

    context "when CSV has one new team" do
      let(:original_league) { Fabricate(:league) }
      let!(:team) do
        Fabricate(:team, name: "Mudhens", identifier: "OLD",
                         league: original_league)
      end

      let(:rows) { [header, first_row, second_row] }

      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "creates one team" do
        expect do
          subject.import
        end.to change(Team, :count).by(1)
      end

      it "updates the existing team's league" do
        expect do
          subject.import
          team.reload
        end.to change(team, :league_id).to(first_league.id)
      end

      it "updates the existing team's identifier" do
        expect do
          subject.import
          team.reload
        end.to change(team, :identifier).to("MUD")
      end

      it "sets second team's attributes" do
        subject.import

        team = Team.find_by!(name: "Gauchos")
        expect(team.league_id).to eq(second_league.id)
        expect(team.identifier).to eq("GCH")
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
