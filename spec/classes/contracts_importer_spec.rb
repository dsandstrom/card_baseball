# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContractsImporter, type: :class do
  let(:first_team) { Fabricate(:team) }
  let(:second_team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }
  let(:pitcher) { Fabricate(:pitcher) }

  let(:file_path) { File.join("tmp", "csv", "contracts.csv") }
  let(:header) { "Team,POS,Player,Roster Name,Contract" }
  let(:hitter_row) do
    "#{first_team.identifier},#{hitter.primary_position},#{hitter.name}," \
      "#{hitter.roster_name},10"
  end
  let(:pitcher_row) do
    "#{second_team.identifier},#{pitcher.primary_position},#{pitcher.name}," \
      "#{pitcher.roster_name},10"
  end

  describe "#import" do
    subject { described_class.new }

    context "when CSV has a hitter and pitcher" do
      let(:rows) { [header, hitter_row, pitcher_row] }
      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      context "when players not on a team" do
        it "creates two contracts" do
          expect do
            subject.import
          end.to change(Contract, :count).by(2)
        end
      end
    end
  end
end
