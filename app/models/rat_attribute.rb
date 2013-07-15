class RatAttribute
  include Mongoid::Document
  field :name, type: String
  field :value, type: Float
end
