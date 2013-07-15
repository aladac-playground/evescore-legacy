class ChargeAttribute
  include Mongoid::Document
  embedded_in :charge
  field :name, type: String
  field :value, type: Float
end
