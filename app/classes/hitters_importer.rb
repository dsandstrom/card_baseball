# frozen_string_literal: true

# TODO: include nickname in csv export

require 'csv'

class HittersImporter
  MAP = {
    bats: 'Bats', speed: 'Spd',
    bunt_grade: 'Bunt', offensive_rating: 'Rating',
    left_hitting: 'vs L', right_hitting: 'vs R',
    left_on_base_percentage: 'LOBP', right_on_base_percentage: 'ROBP',
    left_slugging: 'LSLG', right_slugging: 'RSLG', left_homerun: 'LHR',
    right_homerun: 'RHR', offensive_durability: 'Durability'
  }.freeze
  DEFENSE_MAP = {
    defense1: 'P', defense2: 'C', defense3: '1B', defense4: '2B',
    defense5: '3B', defense6: 'SS', defense7: 'OF', defense8: 'CF',
    bar1: 'P-Bar', bar2: 'C-Bar'
  }.freeze

  attr_accessor :csv_file

  def initialize
    self.csv_file = File.read(file_path)
  end

  def import
    return unless csv_file

    csv = CSV.parse(csv_file, headers: true)
    csv.each do |row|
      roster_name = row['Roster Name']
      next unless roster_name

      player = Player.find_or_initialize_by(roster_name:)
      player.assign_attributes(map_from_csv(row))
      player.save!
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
      File.join(dir_path, 'hitters.csv')
    end

    def map_from_csv(row)
      attrs = {}
      attrs[:first_name], attrs[:last_name] = split_name(row['Player'])
      attrs[:primary_position] = convert_position(row['Pos'])
      attrs = map_attrs(attrs, row)
      map_defense_attrs(attrs, row)
    end

    def split_name(name)
      return ['', ''] if name.blank?

      name.split(/\s/)
    end

    def convert_position(initials)
      return 1 if %w[LR LS RR RS #N/A].include?(initials)

      Player::POSITION_MAP.select do |key, options|
        return key if initials == options[:initials]
      end
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
