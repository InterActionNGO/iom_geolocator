ActiveAdmin.register Geolocation do
  permit_params :uid, :name, :latitude, :longitude, :fclass, :fcode, :country_code, :country_name, :country_uid, :cc2, :admin1, :admin2, :admin3, :admin4, :provider, :adm_level
  filter :uid
  filter :name
  filter :fcode, label: "Fcode", as: :select
  filter :fclass, label: "Fclass", as: :select
  filter :country_name
  filter :country_code
  filter :adm_level
  filter :g0
  filter :g1
  filter :g2
  filter :g3
  filter :g4
  filter :admin1
  filter :admin2
  filter :admin3
  filter :admin4
  index do
    column :id
    column :uid
    column :name
    column :fclass
    column :fcode
    column :country_name
    column :country_code
    column :g0
     column :admin1
    column :g1
     column :admin2
    column :g2
     column :admin3
    column :g3
     column :admin4
    column :g4
    column :adm_level
    actions
  end
end
