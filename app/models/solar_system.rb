class SolarSystem < ActiveRecord::Base
  belongs_to :region
  belongs_to :cons
end
