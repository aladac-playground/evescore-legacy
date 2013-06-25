class Rat
  include Mongoid::Document
  validates :rat_id, :uniqueness => true
  field :rat_id, type: Integer
  field :bounty, type: Integer
  field :rat_name, type: String
  field :rat_type, type: String
  index({ rat_id: 1 }, { unique: true })

  def self.rat_name(id)
    where(:rat_id => id).first.rat_name
  end
  def self.rat_type(id)
    where(:rat_id => id).first.rat_type
  end
end
