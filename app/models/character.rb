class Character
  include Mongoid::Document
  field :char_id, type: Integer
  field :name, type: String
  field :key, type: String
  field :vcode, type: String
  field :last_visit, type: Time
end
