class AddCustomGeoSourceTogeonames < ActiveRecord::Migration
  def change
    add_column :geolocations, :custom_geo_source, :string
  end
end
