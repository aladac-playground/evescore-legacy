class Bounty
  include Mongoid::Document
  field :ts, type: Time
  field :char_id, type: Integer
  field :bounty, type: Integer
  index({ ts: 1, char_id: 1 }, { unique: true })
end
