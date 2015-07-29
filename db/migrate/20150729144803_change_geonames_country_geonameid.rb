class ChangeGeonamesCountryGeonameid < ActiveRecord::Migration
  def change
    rename_column :geolocations, :country_geonameid, :country_uid
    change_column :geolocations, :country_uid, :string
  end
end
