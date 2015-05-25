namespace :db do
  task geo_transform: :environment do
    # check_all_levels
    # particular_cases
    update_adms
    puts "Geos transformed"
  end
end

def check_all_levels
  validate_levels = %Q{
    DELETE from geolocations WHERE
    (admin2 IS NOT NULL AND (admin1 IS NULL OR admin1 ='00')) OR
    (admin3 IS NOT NULL AND (admin1 IS NULL OR admin2 IS NULL OR admin1 ='00' OR admin2 ='00')) OR
    (admin4 IS NOT NULL AND (admin1 IS NULL OR admin2 IS NULL OR admin3 IS NULL OR admin1 ='00' OR admin2 ='00' OR admin3 ='00'))
  }
  ActiveRecord::Base.connection.execute(validate_levels)
end

def particular_cases
  Geolocation.where(country_code: 'BA', adm_level: 3).each do |g|
    unless region = Geolocation.find_by(country_code: 'BA', adm_level: 2, admin2: g.admin2)
      puts g.name
      region = Geolocation.find_by(country_code: 'BA', adm_level: 2, name: g.admin2)
      g.admin2 = region.geonameid
      g.save!
    end
  end
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
  #       WHEN NULL THEN NULL
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=1)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=1 AND admin2 IS NULL)
  #       END
  #   )
  #   , g2 = (
  #       CASE adm_level
  #       WHEN NULL THEN NULL
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=2)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=2 AND admin3 IS NULL)
  #       END
  #   )
  #   , g3 = (
  #       CASE adm_level
  #       WHEN NULL THEN NULL
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN NULL
  #       WHEN 3 THEN geonameid
  #       ELSE (with c as (select geonameid, country_code from geolocations where adm_level=3)SELECT geonameid FROM c  WHERE country_code = geolocations.country_code AND adm_level=3 AND admin4 IS NULL)
  #       END
  #   )
  #   , g4 = (
  #       CASE adm_level
  #       WHEN NULL THEN NULL
  #       WHEN 0 THEN NULL
  #       WHEN 1 THEN NULL
  #       WHEN 2 THEN NULL
  #       WHEN 3 THEN NULL
  #       WHEN 4 THEN geonameid
  #       END
  #   )
  # }
  # ActiveRecord::Base.connection.execute(update_levels)
  Geolocation.where.not(country_code: ['BA','BI','CA','CD','ET','GR','ID','IN','JP','KR','LY','MA','MY','NI','PA','PH','RU','RW','SD','TN','TR','UA','UG','AL']).each do |g|
    puts g.geonameid
    puts g.id
    g.g0 = case g.adm_level
           when 0 then 0
           else Geolocation.where(country_code: g.country_code, adm_level: 0).first.geonameid
           end
    g.g1 = case g.adm_level
           when nil then nil
           when 0 then nil
           when 1 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 1, admin1: g.admin1).first.geonameid
           end
    g.g2 = case g.adm_level
           when nil then nil
           when 0 then nil
           when 1 then nil
           when 2 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 2, admin2: g.admin2).first.geonameid
           end
    g.g3 = case g.adm_level
           when nil then nil
           when 0 then nil
           when 1 then nil
           when 2 then nil
           when 3 then g.geonameid
           else Geolocation.where(country_code: g.country_code, adm_level: 3, admin3: g.admin3).first.geonameid
           end
     g.g4 = case g.adm_level
           when nil then nil
           when 0 then nil
           when 1 then nil
           when 2 then nil
           when 3 then nil
           else g.geonameid
           end
    g.save!
  end
end
