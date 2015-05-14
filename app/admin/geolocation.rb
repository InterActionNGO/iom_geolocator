ActiveAdmin.register Geolocation do
  filter :geonameid
  filter :name
  filter :fcode, label: "Fcode", as: :select
  filter :fclass, label: "Fclass", as: :select
  filter :country_name
  filter :country_code
  filter :adm_level
  filter :admin1
  filter :admin2
  filter :admin3
  filter :admin4
  index do
    column :id
    column :geonameid
    column :name
    column :fclass
    column :fcode
    column :country_name
    column :country_code
    column :admin1
    column :admin2
    column :admin3
    column :admin4
    column :adm_level
    actions
  end
end
