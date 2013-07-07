class Corp
  include Mongoid::Document
  validate :corp_id, :presence => true, :uniqueness => true
  field :name, type: String
  field :corp_id, type: Integer
  index({ corp_id: 1 }, { unique: true, drop_dups: true })
  has_many :characters, primary_key: :corp_id
end
