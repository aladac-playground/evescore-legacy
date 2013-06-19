class Kill
  include Mongoid::Document
  field :ts, type: Time
  field :char_id, type: Integer
  field :rat_id, type: Integer
  field :rat_amount, type: Integer
end
