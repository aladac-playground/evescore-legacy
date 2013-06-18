class Character
  include Mongoid::Document
  validates :key, :presence => true, :numericality => true, :length => 7
  validates :vcode, :presence => true, :length => 64
  field :char_id, type: Integer
  field :name, type: String
  field :key, type: String
  field :vcode, type: String
  field :last_visit, type: Time
end
