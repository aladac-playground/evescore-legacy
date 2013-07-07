class Key
  include Mongoid::Document
  validates :key_id, :presence => true, :uniqueness => { :message => "Key already in use!"}
  field :key_id, type: String
  field :vcode, type: String
  field :access_mask, type: Integer
  field :expires, type: Time
  field :valid, type: Boolean
  index({ key_id: 1 }, { unique: true, drop_dups: true })
  has_many :characters
end
