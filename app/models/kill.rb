class Kill
  include Mongoid::Document
  field :ts, type: Time
  field :char_id, type: Integer
  field :rat_id, type: Integer
  field :bounty, type: Integer
  field :rat_amount, type: Integer
  index({ ts: 1, char_id: 1, rat_id: 1 }, { unique: true })
end
