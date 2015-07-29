class RenameColumnGeolocationsGeonameIdUid < ActiveRecord::Migration
  def change
    rename_column :geolocations, :geonameid, :uid
    change_column :geolocations, :uid, :string
  end
end
