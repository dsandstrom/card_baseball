# frozen_string_literal: true

require 'csv'

class LeaguesImporter
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

      League.find_or_create_by!(name:)
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
      File.join(dir_path, 'leagues.csv')
    end
end
