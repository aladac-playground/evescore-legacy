class Link
  include Mongoid::Document
  field :ts, type: Time
  field :char_id, type: Integer
  field :char_name, type: String
  embeds_many :chars
end
