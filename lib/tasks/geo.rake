require 'csv'
namespace :db do
  task geo: :environment do
    Geolocation.destroy_all
    filename = File.expand_path(File.join(Rails.root, 'db', 'import', "ngo_geo.csv"))
    CSV.foreach(filename, :headers => true, :col_sep => ';') do |row|
      Geolocation.create!(row.to_hash)
    end
    puts "Geos loaded"
  end
end