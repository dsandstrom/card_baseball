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

    context "when CSV has positions with roster info" do
      let(:majors1_catcher) { Fabricate(:hitter, primary_position: 2) }
      let(:majors2_catcher) { Fabricate(:hitter, primary_position: 2) }
      let(:aa_catcher) { Fabricate(:hitter, primary_position: 2) }

      let(:majors1_row) do
        "#{first_team.identifier},C1,#{majors1_catcher.name}," \
          "#{majors1_catcher.roster_name},10"
      end

      let(:majors2_row) do
        "#{first_team.identifier},C2,#{majors2_catcher.name}," \
          "#{majors2_catcher.roster_name},10"
      end

      let(:aa_row) do
        "#{first_team.identifier},2AIF1,#{aa_catcher.name}," \
          "#{aa_catcher.roster_name},10"
      end

      let(:rows) { [header, majors2_row, aa_row, majors1_row] }

      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      context "when players not on a team" do
        it "creates three contracts" do
          expect do
            subject.import
          end.to change(Contract, :count).by(3)
        end

        it "creates three rosters" do
          expect do
            subject.import
          end.to change(Roster, :count).by(3)
        end

        it "adds the majors1 catcher to the majors roster" do
          subject.import

          expect(majors1_catcher.roster).not_to be_nil
          expect(majors1_catcher.roster.level).to eq(4)
          expect(majors1_catcher.roster.position).to eq(2)
          expect(majors1_catcher.roster.row_order_rank).to eq(0)
        end

        it "adds the majors2 catcher to the majors roster" do
          subject.import

          expect(majors2_catcher.roster).not_to be_nil
          expect(majors2_catcher.roster.level).to eq(4)
          expect(majors2_catcher.roster.position).to eq(2)
          expect(majors2_catcher.roster.row_order_rank).to eq(1)
        end

        it "adds the AA catcher to the AA roster" do
          subject.import

          expect(aa_catcher.roster).not_to be_nil
          expect(aa_catcher.roster.level).to eq(2)
          expect(aa_catcher.roster.position).to eq(3)
          expect(aa_catcher.roster.row_order_rank).to eq(0)
        end
      end

      context "when majors1 catcher was on another team" do
        before do
          Fabricate(:roster, team: second_team, player: majors1_catcher,
                             position: 2, level: 4, row_order_position: 0)
          Fabricate(:roster, team: first_team, player: majors2_catcher,
                             position: 2, level: 4, row_order_position: 0)
          Fabricate(:roster, team: first_team, player: aa_catcher,
                             position: 3, level: 2, row_order_position: 0)
        end

        it "doesn't create any rosters" do
          expect do
            subject.import
          end.not_to change(Roster, :count)
        end

        it "changes majors1 catcher roster's team" do
          expect do
            subject.import
            majors1_catcher.roster.reload
          end.to change(majors1_catcher.roster, :team).to(first_team)
        end

        it "doesn't change majors1 catcher roster's position" do
          expect do
            subject.import
            majors1_catcher.roster.reload
          end.not_to change(majors1_catcher.roster, :position)
        end

        it "doesn't change majors1 catcher roster's row_order_rank" do
          expect do
            subject.import
            majors1_catcher.roster.reload
          end.not_to change(majors1_catcher.roster, :row_order_rank)
        end

        it "doesn't change majors2 catcher roster's team" do
          expect do
            subject.import
            majors2_catcher.roster.reload
          end.not_to change(majors2_catcher.roster, :team)
        end

        it "doesn't change majors2 catcher roster's position" do
          expect do
            subject.import
            majors2_catcher.roster.reload
          end.not_to change(majors2_catcher.roster, :position)
        end

        it "changes majors2 catcher roster's row_order_rank" do
          expect do
            subject.import
            majors2_catcher.roster.reload
          end.to change(majors2_catcher.roster, :row_order_rank).to(1)
        end

        it "doesn't change aa catcher roster's team" do
          expect do
            subject.import
            aa_catcher.roster.reload
          end.not_to change(aa_catcher.roster, :team)
        end

        it "doesn't change aa catcher roster's position" do
          expect do
            subject.import
            aa_catcher.roster.reload
          end.not_to change(aa_catcher.roster, :position)
        end

        it "doesn't change aa catcher roster's row_order_rank" do
          expect do
            subject.import
            aa_catcher.roster.reload
          end.not_to change(aa_catcher.roster, :row_order_rank)
        end
      end

      context "when A catcher" do
        let(:hitter) { Fabricate(:hitter, primary_position: 2) }

        let(:row) do
          "#{first_team.identifier},1A1,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "creates one contract" do
          expect do
            subject.import
          end.to change(Contract, :count).by(1)
        end

        it "creates one roster" do
          expect do
            subject.import
          end.to change(Roster, :count).by(1)
        end

        it "adds the a catcher to the A roster" do
          subject.import

          expect(hitter.roster).not_to be_nil
          expect(hitter.roster.level).to eq(1)
          expect(hitter.roster.position).to eq(3)
          expect(hitter.roster.row_order_rank).to eq(0)
        end
      end

      context "when A starting pitcher" do
        let(:pitcher) { Fabricate(:starting_pitcher) }

        let(:row) do
          "#{first_team.identifier},1A1,#{pitcher.name}," \
            "#{pitcher.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "adds the a catcher to the A roster" do
          subject.import

          expect(pitcher.roster).not_to be_nil
          expect(pitcher.roster.level).to eq(1)
          expect(pitcher.roster.position).to eq(1)
          expect(pitcher.roster.row_order_rank).to eq(0)
        end
      end

      context "when A relief pitcher" do
        let(:pitcher) { Fabricate(:relief_pitcher) }

        let(:row) do
          "#{first_team.identifier},1A1,#{pitcher.name}," \
            "#{pitcher.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "adds the a catcher to the A roster" do
          subject.import

          expect(pitcher.roster).not_to be_nil
          expect(pitcher.roster.level).to eq(1)
          expect(pitcher.roster.position).to eq(10)
          expect(pitcher.roster.row_order_rank).to eq(0)
        end
      end

      context "when A infielder" do
        let(:hitter) { Fabricate(:hitter, primary_position: 4) }

        let(:row) do
          "#{first_team.identifier},1A1,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "adds the a catcher to the A roster" do
          subject.import

          expect(hitter.roster).not_to be_nil
          expect(hitter.roster.level).to eq(1)
          expect(hitter.roster.position).to eq(3)
          expect(hitter.roster.row_order_rank).to eq(0)
        end
      end

      context "when A outfielder" do
        let(:hitter) { Fabricate(:hitter, primary_position: 8) }

        let(:row) do
          "#{first_team.identifier},1A1,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "adds the a catcher to the A roster" do
          subject.import

          expect(hitter.roster).not_to be_nil
          expect(hitter.roster.level).to eq(1)
          expect(hitter.roster.position).to eq(7)
          expect(hitter.roster.row_order_rank).to eq(0)
        end
      end

      context "when player doesn't have roster info" do
        let(:hitter) { Fabricate(:hitter, primary_position: 8) }

        let(:row) do
          "#{first_team.identifier},CF,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        let(:rows) { [header, row] }

        it "creates contract" do
          expect do
            subject.import
          end.to change(Contract, :count).by(1)
        end

        it "doesn't create any rosters" do
          expect do
            subject.import
          end.not_to change(Roster, :count)
        end
      end
    end

    context "when hitter has a lineup spot" do
      let(:original_team) { Fabricate(:team) }
      let(:lineup) { Fabricate(:lineup, team: original_team) }
      let(:hitter) { Fabricate(:hitter, primary_position: 2) }
      let(:rows) { [header, row] }

      before do
        Fabricate(:contract, player: hitter, team: original_team)
        Fabricate(:roster, team: original_team, player: hitter, level: 4,
                           position: 2)
        Fabricate(:spot, lineup:, position: hitter.primary_position,
                         player: hitter)

        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      context "and they're staying on the same team" do
        let(:row) do
          "#{original_team.identifier},C1,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        it "doesn't remove any spots" do
          expect do
            subject.import
          end.not_to change(Spot, :count)
        end
      end

      context "and they get moved to a new team" do
        let(:row) do
          "#{first_team.identifier},C1,#{hitter.name}," \
            "#{hitter.roster_name},10"
        end

        it "removes the spot" do
          expect do
            subject.import
          end.to change(Spot, :count).by(-1)
        end
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
