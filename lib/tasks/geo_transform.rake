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
  update_levels = %Q{
    UPDATE geolocations
    SET g0 = (
        CASE adm_level
        WHEN 0 THEN 0
        ELSE (SELECT geonameid FROM geolocations g WHERE country_code = g.country_code AND g.adm_level = 0 LIMIT 1)
        END
    )
    , g1 = (
        CASE adm_level
        WHEN 0 THEN NULL
        WHEN 1 THEN geonameid
        ELSE (SELECT geonameid FROM geolocations g WHERE country_code = g.country_code AND g.adm_level = 1 AND g.admin2 IS NULL LIMIT 1)
        END
    )
    , g2 = (
        CASE adm_level
        WHEN 0 THEN NULL
        WHEN 1 THEN NULL
        WHEN 2 THEN geonameid
        ELSE (SELECT geonameid FROM geolocations g WHERE country_code = g.country_code AND g.adm_level = 2 AND g.admin3 IS NULL LIMIT 1)
        END
    )
    , g3 = (
        CASE adm_level
        WHEN 0 THEN NULL
        WHEN 1 THEN NULL
        WHEN 2 THEN NULL
        WHEN 3 THEN geonameid
        ELSE (SELECT geonameid FROM geolocations g WHERE country_code = g.country_code AND g.adm_level = 3 AND g.admin4 IS NULL LIMIT 1)
        END
    )
    , g4 = (
        CASE adm_level
        WHEN 0 THEN NULL
        WHEN 1 THEN NULL
        WHEN 2 THEN NULL
        WHEN 3 THEN NULL
        WHEN 4 THEN geonameid
        END
    )
  }
  ActiveRecord::Base.connection.execute(update_levels)
end