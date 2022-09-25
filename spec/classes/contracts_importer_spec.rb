# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContractsImporter, type: :class do
  let(:first_team) { Fabricate(:team) }
  let(:second_team) { Fabricate(:team) }
  let(:hitter) { Fabricate(:hitter) }
  let(:pitcher) { Fabricate(:pitcher) }

  let(:file_path) { File.join(dir_path, "contracts.csv") }
  let(:header) { "Team,POS,Player,Roster Name,Contract" }

  let(:hitter_row) do
    "#{first_team.identifier},#{hitter.primary_position},#{hitter.name}," \
      "#{hitter.roster_name},10"
  end

  let(:pitcher_row) do
    "#{second_team.identifier},#{pitcher.primary_position},#{pitcher.name}," \
      "#{pitcher.roster_name},11"
  end

  before(:all) do
    FileUtils.mkdir_p(dir_path)
  end

  after(:each) { File.delete(file_path) }

  describe "#import" do
    subject { described_class.new }

    context "when CSV has a hitter and pitcher" do
      let(:rows) { [header, hitter_row, pitcher_row] }

      context "when players not on a team" do
        before do
          CSV.open(file_path, "w") do |csv|
            rows.each do |row|
              csv << row.split(",")
            end
          end
        end

        it "creates two contracts" do
          expect do
            subject.import
          end.to change(Contract, :count).by(2)
        end

        it "adds the hitter to the first_team" do
          subject.import

          expect(hitter.contract.team).to eq(first_team)
          expect(hitter.contract.length).to eq(1)
        end

        it "adds the pitcher to the second_team" do
          subject.import

          expect(pitcher.contract.team).to eq(second_team)
          expect(pitcher.contract.length).to eq(2)
        end
      end

      context "and the hitter is already on a different team" do
        let(:original_team) { Fabricate(:team) }
        let(:pitcher_row) do
          "#{second_team.identifier},#{pitcher.primary_position}," \
            "#{pitcher.name},#{pitcher.roster_name},12"
        end

        before do
          Fabricate(:contract, player: hitter, team: original_team)
          Fabricate(:contract, player: pitcher, team: second_team)

          CSV.open(file_path, "w") do |csv|
            rows.each do |row|
              csv << row.split(",")
            end
          end
        end

        it "doesn't create any new contracts" do
          expect do
            subject.import
          end.not_to change(Contract, :count)
        end

        it "moves the hitter to the first_team" do
          expect do
            subject.import
            hitter.contract.reload
          end.to change(hitter.contract, :team).to(first_team)

          expect(hitter.contract.length).to eq(1)
        end

        it "doesn't change the pitcher's team" do
          expect do
            subject.import
            pitcher.contract.reload
          end.not_to change(pitcher.contract, :team)

          expect(pitcher.contract.length).to eq(3)
        end
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
