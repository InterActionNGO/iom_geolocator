require 'csv'
namespace :db do
  task geo: :environment do
    Geolocation.destroy_all
    filename = File.expand_path(File.join(Rails.root, 'db', 'import', "geo_locations.csv"))
    CSV.foreach(filename, :headers => true) do |row|
      Geolocation.create!(row.to_hash)
    end
    puts "Geos loaded"
  end
end