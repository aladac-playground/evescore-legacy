class Charge
  include Mongoid::Document
  embeds_many :charge_attributes
  validates_uniqueness_of :name, :charge_id
  field :charge_id, type: Integer
  field :name, type: String
  field :type, type: String
end
