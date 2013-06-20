module ApplicationHelper
  def character_name(id)
    character = Character.where(char_id: id).first
    return character[:name]
  end
  def rat_name(id)
    rat = Rat.where(rat_id: id).first
    return rat[:rat_name]
  end
  def rat_image(id, size=64)
    return "http://image.eveonline.com/Type/#{id}_#{size}.png"
  end
  def character_image(id, size=64)
    return "http://image.eveonline.com/Character/#{id}_#{size}.jpg"
  end
  def top_bounty(limit=4)
    top = Bounty.collection.aggregate( { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def rat_bounty(id)
    bounty = Rat.where(rat_id: id).first[:bounty]
    return bounty
  end
  def top_kills_10days(limit=4)
    top = Kill.
      collection.aggregate(  { "$match" => { "ts" => { "$gt" => (Time.now.utc - 10.days) } } }, { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$rat_amount"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def top_bounty_10days(limit=4)
    top = Bounty.
      collection.aggregate(  { "$match" => { "ts" => { "$gt" => (Time.now.utc - 10.days) } } }, { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def highest_bounty_10days(limit=5)
    bounty = Kill.where(:ts.gt => (Time.now.utc - 10.days)).sort(:bounty.desc).limit(limit)
    return bounty
  end
  def top_monthly(limit=4)
    top = Bounty.
      collection.aggregate(  { "$match" => { "ts" => { "$gt" => Time.now.utc.at_beginning_of_month.utc } } }, { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def isk(amount)
    isk = number_to_currency(amount, :unit => "ISK", :precision => 0, :delimiter => ",", :format => "%n %u")
    return isk
  end
end
