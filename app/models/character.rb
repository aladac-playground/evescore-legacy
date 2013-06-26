class Character
  include Mongoid::Document
  validates :key, :presence => true, :numericality => true, :length => { :is => 7 }
  validates :vcode, :presence => true, :length => { :is => 64 }
  validates :char_id, :presence => true, :uniqueness => { :message => "Character already in use!"}
  validates :name, :presence => true
  field :char_id, type: Integer
  field :name, type: String
  field :key, type: String
  field :vcode, type: String
  field :last_visit, type: Time
  index({  char_id: 1 }, { unique: true })
end
