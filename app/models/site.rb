class Site < ActiveRecord::Base
  validates_uniqueness_of :name
  has_many :rats
end
