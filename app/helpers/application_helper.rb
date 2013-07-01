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
    src = "rats/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("rat", id, size)
    end
    image_tag src, :class => "img-rounded ttp", :style => "margin: 2px", :title => Rat.rat_name(id) + "<br>" + Rat.rat_type(id)
  end
  def rat_image_link(id, size=64)
    src = "rats/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("rat", id, size)
    end
    link_to image_tag(src, :class => "img-rounded"), kills_log_path(:filter => { :rat_id => id } )
  end
  def character_image(id, size=64)
    src = "characters/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    image_tag(src, :class => "img-rounded")
  end
  def character_image_link(id, size=64)
    src = "characters/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    link_to image_tag(src, :class => "img-rounded"), character_profile_path( :char_id => id )
  end
  def character_tick_link(id, tick, size=64)
    src = "characters/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    link_to image_tag(src, :class => "img-rounded"), kills_log_path(:filter => { :_id => tick } )
  end
  def top_bounty(limit=5)
    return Bounty.top_bounty(limit)
  end
  def rat_bounty(id)
    bounty = Rat.where(rat_id: id).first[:bounty]
    return bounty
  end
  def top_bounty_10days(limit=5)
    return Bounty.top_bounty_days(10, limit)
  end
  def top_kills(limit=5)
    return Bounty.top_kills(limit)
  end
  def top_kills_10days(limit=5)
    return Bounty.top_kills_days(10, limit)
  end
  def highest_tick_10days(limit=5)
    return Bounty.highest_tick_days(10, limit)
  end
  def highest_tick(limit=5)
    return Bounty.highest_tick(limit)
  end
  def kill_rank(char_id)
    Bounty.kill_rank(char_id)
  end
  def tick_rank(char_id)
    Bounty.tick_rank(char_id)
  end
  def bounty_rank(char_id)
    Bounty.bounty_rank(char_id)
  end
  def isk_short(amount)
    isk = number_to_human(amount/100)
    isk.gsub!(/ Million/,"M ISK")
    isk.gsub!(/ Billion/,"b ISK")
    isk.gsub!(/ Thousand/,"k ISK")
    return isk
  end
  def isk(amount)
    isk = number_to_currency(amount, :unit => "ISK", :precision => 0, :delimiter => ",", :format => "%n %u")
    return isk
  end
  def ext_image(type, id, size)
    require 'net/http'
    dir = "Type" if type == "rat"
    dir = "Character" if type == "character"
    ext = "jpg" if type == "character"
    ext = "png" if type == "rat"
    return "http://image.eveonline.com/#{dir}/#{id}_#{size}.#{ext}"
  end
end
