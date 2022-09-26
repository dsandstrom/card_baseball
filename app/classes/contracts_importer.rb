# frozen_string_literal: true

require 'csv'

class ContractsImporter
  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(file_path)
  end

  def import
    return unless csv_file

    Roster.destroy_all

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      contract = save_contract(row)
      contract.player.reload
      save_roster(contract, row['POS'])
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
      File.join(dir_path, 'contracts.csv')
    end

    def save_contract(row)
      roster_name = row['Roster Name']
      return unless roster_name

      player = Player.find_by!(roster_name:)
      original_team = player.team
      team = Team.find_by!(identifier: row['Team'])
      contract = player.contract || player.build_contract
      contract.assign_attributes(team:, length: convert_length(row['Contract']))
      contract.save!

      player.spots.destroy_all if team != original_team
      contract
    end

    # POS can be "SP1", "SP2", "3ASP2", "OF1", "2AOF1", "1A2"
    def save_roster(contract, imported_position)
      attrs = Roster.imported_attrs(imported_position)
      return unless attrs

      roster = contract.player.roster || contract.player.build_roster
      attrs[:position] ||= level1_position(contract.player)
      roster.assign_attributes(attrs.merge(team: contract.team))
      roster.save!
    end

    def convert_length(csv_length)
      return unless csv_length

      csv_length.to_i - 9
    end

    def level1_position(player)
      case player.primary_position
      when 1
        player.pitcher_type == 'S' ? 1 : 10
      when 2..6
        3
      when 7, 8
        7
      end
    end
end
