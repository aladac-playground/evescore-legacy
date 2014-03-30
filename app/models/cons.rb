class Cons < ActiveRecord::Base
  belongs_to :region
  has_many :solar_systems
end
