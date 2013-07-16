class RatAttribute
  include Mongoid::Document
  validates_uniqueness_of :name
  field :name, type: String
  field :value, type: Float
end
