class Kill
  include Mongoid::Document
  before_validation :generate_id
  validates_uniqueness_of :ts, :scope => [ :char_id, :rat_id ] 
  validates_presence_of :ts, :char_id, :rat_id, :bounty, :rat_amount
  field :_id, type: Integer
  field :ts, type: Time
  field :char_id, type: Integer
  field :rat_id, type: Integer
  field :bounty, type: Integer
  field :rat_amount, type: Integer
  index({ ts: 1, char_id: 1, rat_id: 1 }, { unique: true })

  private
  def generate_id
    # self._id ||= "#{rat_id.to_s}:#{ts.to_s}"
    self._id ||= rat_id + ts.to_i + char_id
  end
end
