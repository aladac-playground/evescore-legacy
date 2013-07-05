class Bounty
  include Mongoid::Document
  validates_uniqueness_of :ts, :scope => [ :char_id ]
  validates_presence_of :ts, :char_id, :bounty
  field :ts, type: Time
  field :char_id, type: Integer
  field :bounty, type: Integer
  index({ ts: 1, char_id: 1 }, { unique: true, drop_dups: true })
  embeds_many :kills

  def self.total_bounty(id)
    Bounty.where(char_id: id).sum(:bounty) / 100
  end
  def self.total_kills(id)
    Bounty.collection.aggregate({ "$match" => { "char_id" => id }}, { "$unwind" => "$kills" } ).count
  end

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
  def self.top_daily(char_id)
    collection.aggregate( 
                         { "$match" => { "char_id" => char_id } }, 
                         { "$group" => { "_id" => 
                           { 
                             "year" => { "$year" => "$ts" }, 
                             "month" => { "$month" => "$ts" }, 
                             "day" => { "$dayOfMonth" => "$ts" } 
                           }, 
                             "sum" => { "$sum" => "$bounty"} } }, 
                             {"$sort" => { "sum" => -1 } }  
                        ).first["sum"]/100
  end
  def self.top_kills_this_month(limit=5)
    limit -= 1
    collection.aggregate( 
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc.at_beginning_of_month) } } },
                         {"$unwind" => "$kills"}, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "kills" => { "$sum" => 1 } 
                           } 
                         }, 
                         { "$sort" => 
                           { "kills" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.kills_this_month(id)
    collection.aggregate( 
                         { "$match" => { "char_id" => id, "ts" => { "$gt" => (Time.now.utc.at_beginning_of_month) } } },
                         {"$unwind" => "$kills"}
                        ).count
  end
  def self.top_kills_days(days=10, limit=5)
    limit -= 1
    collection.aggregate( 
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc - days.days) } } },
                         {"$unwind" => "$kills"}, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "kills" => { "$sum" => 1 } 
                           } 
                         }, 
                         { "$sort" => 
                           { "kills" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.top_kills(limit=5)
    limit -= 1
    collection.aggregate( 
                         {"$unwind" => "$kills"}, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "kills" => { "$sum" => 1 } 
                           } 
                         }, 
                         { "$sort" => 
                           { "kills" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.top_bounty_days(days=10, limit=5)
    limit -= 1
    collection.aggregate(  
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc - days.days) } } }, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "sum" => 
                              { "$sum" => "$bounty"}  
                           } 
                         }, 
                         {"$sort" => 
                           { "sum" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.top_bounty_this_month(limit=5)
    limit -= 1
    collection.aggregate(  
                         { "$match" => { "ts" => { "$gt" => (Time.now.utc.at_beginning_of_month) } } }, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "sum" => 
                              { "$sum" => "$bounty"}  
                           } 
                         }, 
                         {"$sort" => 
                           { "sum" => -1 } 
                         } 
                        )[0..limit]
  end
  def self.bounty_this_month(id)
    collection.aggregate(  
                         { "$match" => { "char_id" => id, "ts" => { "$gt" => (Time.now.utc.at_beginning_of_month) } } }, 
                         { "$group" => 
                           { 
                             "_id" => "$char_id", 
                             "sum" => 
                              { "$sum" => "$bounty"}  
                           } 
                         }, 
                         {"$sort" => 
                           { "sum" => -1 } 
                         } 
                        ).first["sum"]/100
  end
  def self.top_bounty(limit=5)
    limit -= 1
    collection.aggregate( 
                         { "$group" => 
                           { "_id" => 
                             "$char_id", "sum" => { "$sum" => "$bounty"}  
                           } 
                         }, 
                         {"$sort" => { "sum" => -1 } } 
                        )[0..limit]
  end  
  def self.bounty_rank(char_id)
    rank=0
    Bounty.top_bounty(0).each do |entry|
      rank+=1
      if entry["_id"] == char_id
        result = rank
        break
      end
    end
    return rank
  end
  def self.kill_rank(char_id)
    rank=0    
    Bounty.top_kills(0).each do |entry|
      rank+=1
      if entry["_id"] == char_id
        break
      end
    end
    return rank
  end
  def self.highest_tick_days(days=10, limit=5)
    where(:ts.gt => (Time.now.utc - days.days)).sort(:bounty.desc).limit(limit)
  end
  def self.highest_tick(limit=5)
    all.sort(:bounty.desc).limit(limit)
  end
  def self.top_tick(id)
    where(char_id: id).max(:bounty)/100
  end
  def self.avg_tick(id)
    where(char_id: id).avg(:bounty)/100
  end
  def self.tick_rank(char_id)
    rank=0
    Bounty.highest_tick(0).to_a.each do |tick|
      rank+=1
      if tick.char_id == char_id
        break
      end
    end
    return rank
  end
  def self.unique_rats
    Bounty.collection.aggregate({ "$unwind" => "$kills" }, { "$group" => { "_id" => "$kills.rat_id" } } )
  end
end
