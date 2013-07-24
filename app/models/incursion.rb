class Incursion
  include Mongoid::Document
  field :ts, type: Time
  field :char_id, type: Integer
  field :corp_id, type: Integer
  field :reward, type: Integer
  index({ ts: 1, char_id: 1 }, { unique: true, drop_dups: true })
  index({ ts: -1 })
  index({ ts: 1 })
  index({ char_id: 1})
  index({ reward: 1 })
  index({ reward: -1 })
  
  def self.top_incursion(limit=5)
    limit -= 1
    collection.aggregate( 
                         { "$group" => 
                           { "_id" => 
                             "$char_id", "sum" => { "$sum" => "$reward"}  
                           } 
                         }, 
                         {"$sort" => { "sum" => -1 } } 
                        )[0..limit]
  end  
  def self.top_incursion_this_month(limit=5)
    limit -= 1
    collection.aggregate(  
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc.at_beginning_of_month) } } }, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "sum" => 
                              { "$sum" => "$reward"}  
                           } 
                         }, 
                         {"$sort" => 
                           { "sum" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.top_incursion_days(days=10, limit=5)
    limit -= 1
    collection.aggregate(  
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc - days.days) } } }, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "sum" => 
                              { "$sum" => "$reward"}  
                           } 
                         }, 
                         {"$sort" => 
                           { "sum" => -1 } 
                         } 
                        )[0..limit]
  end  
end
