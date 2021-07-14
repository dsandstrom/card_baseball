# frozen_string_literal: true

require 'csv'

class ContractsImporter
  FILE_PATH = %w[tmp csv contracts.csv].freeze

  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(File.join(FILE_PATH))
  end

  def import
    return unless csv_file

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      save_contract(row)
    end
  end

  private

    def save_contract(row)
      roster_name = row['Roster Name']
      return unless roster_name

      player = Player.find_by!(roster_name: roster_name)
      team = Team.find_by!(identifier: row['Team'])
      contract = player.contract || player.build_contract
      contract.assign_attributes(team_id: team.id,
                                 length: convert_length(row['Contract']))
      contract.save!
    end

    def convert_length(csv_length)
      return unless csv_length

      csv_length.to_i - 9
    end
end
