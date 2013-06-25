class Bounty
  include Mongoid::Document
  before_validation :generate_id
  validates_uniqueness_of :ts, :scope => [ :char_id ]
  validates_presence_of :ts, :char_id, :bounty
  field :ts, type: Time
  field :char_id, type: Integer
  field :bounty, type: Integer
  index({ ts: 1, char_id: 1 }, { unique: true })

  def self.daily(char_id, limit=10)
    limit -= 1
    collection.aggregate( 
                         { "$match" => { "char_id" => char_id } }, 
                         { "$group" => { "_id" => 
                           { 
                             "char_id" => "$char_id", 
                             "year" => { "$year" => "$ts" }, 
                             "month" => { "$month" => "$ts" }, 
                             "day" => { "$dayOfMonth" => "$ts" } 
                           }, 
                             "sum" => { "$sum" => "$bounty"} } }, 
                             {"$sort" => { "_id" => -1 } }  
                        )[0..limit]
  end

  private
  def generate_id
    self._id ||= ts.to_i + char_id
  end
end
