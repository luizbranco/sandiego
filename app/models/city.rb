class City < ActiveRecord::Base
  has_many :clues
  has_many :tracks
  has_many :missions, :through => :tracks

end
