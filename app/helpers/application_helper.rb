module ApplicationHelper
  def character_name(id)
    character = Character.where(char_id: id).first
    return character[:name]
  end
  def rat_name(id)
    rat = Rat.where(rat_id: id).first
    return rat[:rat_name]
  end
  def rat_image(id)
    return "http://image.eveonline.com/Type/#{id}_32.png"
  end
  def character_image(id)
    return "http://image.eveonline.com/Character/#{id}_32.jpg"
  end
  def top_bounty(limit=4)
    top = Bounty.collection.aggregate( { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def top_monthly(limit=4)
    top = Bounty.
      where(:ts.gt => Time.now.utc.at_beginning_of_month.utc ).
      collection.aggregate( { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def isk(amount)
    isk = number_to_currency(amount, :unit => "ISK", :precision => 0, :delimiter => ",", :format => "%n %u")
    return isk
  end
end
