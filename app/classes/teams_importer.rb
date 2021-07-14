# frozen_string_literal: true

require 'csv'

class TeamsImporter
  FILE_PATH = %w[tmp csv teams.csv].freeze

  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(File.join(FILE_PATH))
  end

  def import
    return unless csv_file

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      name = row['Name']
      next unless name

      league = League.find_by!(name: row['League'])
      team = Team.find_or_initialize_by(name: name)
      team.assign_attributes(league_id: league.id, identifier: row['ID'])
      team.save!
    end
  end
end
