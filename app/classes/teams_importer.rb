# frozen_string_literal: true

require 'csv'

class TeamsImporter
  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(file_path)
  end

  def import
    return unless csv_file

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      name = row['Name']
      next unless name

      league = League.find_by!(name: row['League'])
      team = Team.find_or_initialize_by(name:)
      team.assign_attributes(league_id: league.id, identifier: row['ID'])
      team.save!
    end
  end

  private

    def file_path
      dir_path =
        if Rails.env.test?
          %w[tmp test csv].freeze
        else
          %w[tmp csv].freeze
        end
      File.join(dir_path, 'teams.csv')
    end
end
