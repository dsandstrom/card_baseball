namespace :import do
  desc 'run ContractsImporter'
  task contracts: :environment do |t|
    puts 'running Contracts Importer'
    puts "#{Contract.count} #{'contract'.pluralize Contract.count} before"
    ContractsImporter.new.import
    puts "#{Contract.count} #{'contract'.pluralize Contract.count} after"
  end

  desc 'running Hitters Importer'
  task hitters: :environment do |t|
    puts 'running Hitters Importer'
    puts "#{Player.count} #{'player'.pluralize Player.count} before"
    HittersImporter.new.import
    puts "#{Player.count} #{'player'.pluralize Player.count} after"
  end

  desc 'running Pitchers Importer'
  task pitchers: :environment do |t|
    puts 'running Pitchers Importer'
    puts "#{Player.count} #{'player'.pluralize Player.count} before"
    PitchersImporter.new.import
    puts "#{Player.count} #{'player'.pluralize Player.count} after"
  end

  desc 'running Leagues Importer'
  task leagues: :environment do |t|
    puts 'running Leagues Importer'
    puts "#{League.count} #{'league'.pluralize League.count} before"
    LeaguesImporter.new.import
    puts "#{League.count} #{'league'.pluralize League.count} after"
  end

  desc 'running Teams Importer'
  task teams: :environment do |t|
    puts 'running Teams Importer'
    puts "#{Team.count} #{'team'.pluralize Team.count} before"
    TeamsImporter.new.import
    puts "#{Team.count} #{'team'.pluralize Team.count} after"
  end
end
