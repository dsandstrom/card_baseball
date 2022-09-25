# frozen_string_literal: true

require "rails_helper"

RSpec.describe LeaguesImporter, type: :class do
  # let(:first_league) { Fabricate(:league) }
  # let(:second_league) { Fabricate(:league) }

  let(:file_path) { File.join(dir_path, "leagues.csv") }
  let(:header) { "Name" }
  let(:first_row) { "Midwest League" }
  let(:second_row) { "Cactus League" }

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
        end.to change(League, :count).by(2)
      end

      it "sets first leagues's name" do
        subject.import

        expect(League.find_by(name: "Midwest League")).not_to be_nil
      end

      it "sets second leagues's name" do
        subject.import

        expect(League.find_by(name: "Cactus League")).not_to be_nil
      end
    end

    context "when CSV has one new league" do
      let(:league) { Fabricate(:league) }
      let(:first_row) { league.name }
      let(:rows) { [header, first_row, second_row] }

      before do
        CSV.open(file_path, "w") do |csv|
          rows.each do |row|
            csv << row.split(",")
          end
        end
      end

      it "creates one league" do
        expect do
          subject.import
        end.to change(League, :count).by(1)
      end

      it "sets first leagues's name" do
        subject.import

        expect do
          subject.import
          league.reload
        end.not_to change(league, :name)
      end

      it "sets second leagues's name" do
        subject.import

        expect(League.find_by(name: "Cactus League")).not_to be_nil
      end
    end
  end

  def dir_path
    File.join("tmp", "test", "csv")
  end
end
