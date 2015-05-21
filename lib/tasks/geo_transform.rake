namespace :db do
  task geo_transform: :environment do
    #check_all_levels
    update_adms
  end
  puts "Geos transformed"
end

def check_all_levels
  validate_levels = %Q{
    DELETE from geolocations WHERE
    (admin1 IS NULL) OR
    (adm_level = 2 AND (admin1 IS NULL)) OR
    (adm_level = 3 AND (admin1 IS NULL OR admin2 IS NULL)) OR
    (adm_level = 4 AND (admin1 IS NULL OR admin2 IS NULL OR admin3 IS NULL))
  }
  ActiveRecord::Base.connection.execute(validate_levels)
end

def update_adms
  # update_levels = %Q{
  #   UPDATE geolocations
  #   SET g0 = (
  #       CASE adm_level
  #       WHEN 0 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=0)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code )
  #       END
  #   )
  #   , g1 = (
  #       CASE adm_level
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=1)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=1 AND admin2 IS NULL)
  #       END
  #   )
  #   , g2 = (
  #       CASE adm_level
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=2)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=2 AND admin3 IS NULL)
  #       END
  #   )
  #   , g3 = (
  #       CASE adm_level
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN NULL
  #       WHEN 3 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=3)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=3 AND admin4 IS NULL)
  #       END
  #   )
  #   , g4 = (
  #       CASE adm_level
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN NULL
  #       WHEN 3 THEN NULL
  #       WHEN 4 THEN geonameid
  #       END
  #   )
  # }
  # ActiveRecord::Base.connection.execute(update_levels)
  Geolocation.where(country_code: 'ES').each do |g|
    puts g.geonameid
    g.g0 = case g.adm_level
           when 0 then 0
           else Geolocation.where(country_code: g.country_code, adm_level: 0).first.geonameid
           end
    g.g1 = case g.adm_level
           when 0 then nil
           when 1 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 1, admin1: g.admin1).first.geonameid
           end
    g.g2 = case g.adm_level
           when 0 then nil
           when 1 then nil
           when 2 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 2, admin2: g.admin2).first.geonameid
           end
    g.g3 = case g.adm_level
           when 0 then nil
           when 1 then nil
           when 2 then nil
           when 3 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 3, admin3: g.admin3).first.geonameid
           end
     g.g4 = case g.adm_level
           when 0 then nil
           when 1 then nil
           when 2 then nil
           when 3 then nil
           else g.geonameid
           end
    g.save!
  end
end
