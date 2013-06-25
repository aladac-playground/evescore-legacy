class Kill
  include Mongoid::Document
  validates_presence_of :rat_id, :rat_amount
  embedded_in :bounty
  field :rat_id, type: Integer
  field :rat_amount, type: Integer
  index({ rat_id: 1 }, { unique: true, drop_dups: true })
end
