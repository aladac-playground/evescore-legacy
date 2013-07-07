class Corp
  include Mongoid::Document
  field :name, type: String
  field :corp_id, type: Integer
end
