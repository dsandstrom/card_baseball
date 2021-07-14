# frozen_string_literal: true

require 'csv'

class LeaguesImporter
  FILE_PATH = %w[tmp csv leagues.csv].freeze

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

      League.find_or_create_by!(name: name)
    end
  end
end
