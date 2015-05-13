# == Schema Information
#
# Table name: geolocations
#
#  id                :integer          not null, primary key
#  geonameid         :integer
#  name              :string
#  latitude          :float
#  longitude         :float
#  fclass            :string
#  fcode             :string
#  country_code      :string
#  country_name      :string
#  country_geonameid :integer
#  cc2               :string
#  admin1            :string
#  admin2            :string
#  admin3            :string
#  admin4            :string
#  provider          :string           default("Geonames")
#  adm_level         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Geolocation < ActiveRecord::Base
  before_save :set_adm_level

  def set_adm_level
    if self.fcode.present? && self.fcode[0..2] == 'ADM' && self.fcode[3..4].to_i.to_s == self.fcode[3..4]
      self.adm_level = self.fcode[3..4].to_i
    else
      self.adm_level = 0
    end
  end

end
