# frozen_string_literal: true

require 'csv'

class PitchersImporter
  FILE_PATH = %w[tmp csv pitchers.csv].freeze
  MAP = {
    pitcher_rating: 'Rating', starting_pitching: 'Starter',
    relief_pitching: 'Reliever', pitching_durability: 'Dur'
  }.freeze
  DEFENSE_MAP = { defense1: 'Def', bar1: 'Bar' }.freeze

  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(File.join(FILE_PATH))
  end

  def import
    return unless csv_file

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      roster_name = row['Roster Name']
      next unless roster_name

      player = Player.find_or_initialize_by(roster_name: roster_name)
      player.assign_attributes(map_from_csv(row))
      player.save!
    end
  end

  private

    def map_from_csv(row)
      attrs = {}
      attrs[:first_name], attrs[:last_name] = split_name(row['Pitcher'])
      attrs[:throws], attrs[:pitcher_type] = split_type(row['Type'])
      attrs[:primary_position] = 1
      attrs = map_attrs(attrs, row)
      map_defense_attrs(attrs, row)
    end

    def split_name(name)
      return ['', ''] if name.blank?

      name.split(/\s/)
    end

    def split_type(type)
      return ['', ''] if type.blank?

      [type[0], type[1]]
    end

    def map_attrs(attrs, csv_row)
      MAP.each do |key, csv_key|
        attrs[key] = csv_row[csv_key]
      end
      attrs
    end

    def map_defense_attrs(attrs, csv_row)
      DEFENSE_MAP.each do |key, csv_key|
        attrs[key] = convert_defense(csv_row[csv_key])
      end
      attrs
    end

    def convert_defense(defense_string)
      return unless defense_string

      if defense_string == '0'
        0
      elsif %w[+ -].include?(defense_string[0])
        defense_string.gsub(/\s/, '').to_i
      else
        defense_string.to_i
      end
    end
end
