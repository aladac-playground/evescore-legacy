module ApplicationHelper
  def character_name(id, len=15)
    character = Character.where(char_id: id).first
    return truncate character[:name], :length => len
  end
  def character_name_link(id, len=15)
    character = Character.where(char_id: id).first
    link_to truncate(character[:name], :length => len), character_profile_path( :char_id => id  )
  end
  def rat_name(id, len=18)
    rat = Rat.where(rat_id: id).first
    return truncate rat[:rat_name], :length => len
  end
  def rat_name_link(id, len=18)
    rat = Rat.where(rat_id: id).first
    link_to truncate(rat[:rat_name], :length => len), kills_log_path(:filter => { :rat_id => id } )
  end
  def rat_image(id, size=64)
    return "http://image.eveonline.com/Type/#{id}_#{size}.png"
  end
  def rat_image_link(id, size=64)
    link_to image_tag("http://image.eveonline.com/Type/#{id}_#{size}.png", :class => "img-rounded"), kills_log_path(:filter => { :rat_id => id } )
  end
  def character_image(id, size=64)
    image_tag("http://image.eveonline.com/Character/#{id}_#{size}.jpg", :class => "img-rounded")
  end
  def character_image_link(id, size=64)
    link_to image_tag("http://image.eveonline.com/Character/#{id}_#{size}.jpg", :class => "img-rounded"), character_profile_path( :char_id => id )
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
  def highest_bounty(limit=5)
    bounty = Kill.all.sort(:bounty.desc).limit(limit)
    return bounty
  end
  def highest_tick_10days(limit=5)
    bounty = Bounty.where(:ts.gt => (Time.now.utc - 10.days)).sort(:bounty.desc).limit(limit)
    return bounty
  end
  def top_monthly(limit=4)
    top = Bounty.
      collection.aggregate(  { "$match" => { "ts" => { "$gt" => Time.now.utc.at_beginning_of_month.utc } } }, { "$group" => { "_id" => "$char_id", "sum" => { "$sum" => "$bounty"}  } }, {"$sort" => { "sum" => -1 } } )[0..limit]
    return top
  end
  def isk_short(amount)
    isk = number_to_human(amount)
    isk.gsub!(/ Million/,"M ISK")
    isk.gsub!(/ Billion/,"b ISK")
    isk.gsub!(/ Thousand/,"k ISK")
    return isk
  end
  def isk(amount)
    isk = number_to_currency(amount, :unit => "ISK", :precision => 0, :delimiter => ",", :format => "%n %u")
    return isk
  end
end
