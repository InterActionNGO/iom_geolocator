class AddGsToGeolocations < ActiveRecord::Migration
  def change
    add_column :geolocations, :g0, :string
    add_column :geolocations, :g1, :string
    add_column :geolocations, :g2, :string
    add_column :geolocations, :g3, :string
    add_column :geolocations, :g4, :string
  end
end
