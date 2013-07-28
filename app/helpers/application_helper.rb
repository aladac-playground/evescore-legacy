module ApplicationHelper
  def search_data
    @search = Array.new
    Corp.all.each do |corp|
      c = { 
        name: corp.name,
        value: corp.corp_id,
        type: "Corporation",
        image: "corps/#{corp.corp_id}_32.png"
      }
      @search.push c
    end
    Character.all.each do |char|
      c = { 
        name: char.name,
        value: char.char_id,
        type: "Character",
        image: "characters/#{char.char_id}_32.png"
      }
      @search.push c
    end
    Rat.all.each do |rat|
      c = { 
        name: rat.rat_name,
        value: rat.rat_id,
        type: "Rat",
        image: "rats/#{rat.rat_id}_32.png"
      }
      @search.push c
    end
    @search.to_json
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  def cache_key
    count = Bounty.count
    key = params[:controller].to_s + params[:action].to_s + count.to_s
    key += params[:char_id].to_s if params[:char_id]
    key += params[:char_name].to_s if params[:char_name]
    key += params[:page].to_s if params[:page]
    key += params[:corp_id].to_s if params[:corp_id]
    key += params[:filter].to_s if params[:filter]
    return key
  end
  def tweets
    tweets=Twitter.user_timeline(:count => 3)
    news = Hash.new
    tweets.each do |t|
      ts = Time.parse(t.attrs[:created_at]).utc.strftime("%Y-%m-%d %H:%M")
      tmp = { ts => t.attrs[:text] }
      news.merge! tmp
    end
    news
  end
  def tax_this_month(id)
    tax = Bounty.tax_this_month(id)
    if tax
      return tax.first / 100
    else
      return 0
    end
  end
  def tax_daily(id)
    tax = Bounty.tax_daily(id)
    if tax
      return tax.first / 100
    else
      return 0
    end
  end
    
  def corp_name_link(id, len=19)
    corp = Corp.where(corp_id: id).first
    link_to truncate(corp[:name], :length => len), corp_profile_path( :corp_id => id )
  end
  def corp_name(id)
    corp = Corp.where(corp_id: id).first
    corp.name
  end
  def character_name(id, len=15)
    character = Character.where(char_id: id).first
    return truncate character[:name], :length => len
  end
  def character_name_link(id, len=15)
    character = Character.where(char_id: id).first
    name = character.name
    link_to truncate(character[:name], :length => len), character_profile_path( :char_name => name  )
  end
  def rat_name(id, len=18)
    rat = Rat.where(rat_id: id).first
    return truncate rat[:rat_name], :length => len
  end
  def pirate_logo(name)
    logo = "skull.png"
    if name =~ /Guristas/
      logo = "guristas.png"
      title = $&
    end
    if name =~ /Angel Cartel/
      logo = "angels.png"
      title = $&
    end
    if name =~ /Serpentis/
      logo = "serpentis.png"
      title = "Serpentis Corporation  "
    end
    if name =~ /Blood Raiders/
      logo = "blood.png"
      title = $&
    end
    if name =~ /Sansha's Nation/
      logo = "sansha.png"
      title = $&
    end
    image_tag( "icons/" + logo, :style => "height: 18px", :class => "img-rounded ttp", :title => title )
  end
  def ship_class(name)
    if name =~ /.*\b(.*)\b$/
      ship_class = $1
    end
  end
  def rat_type(id, len=18)
    rat = Rat.where(rat_id: id).first
    return truncate rat[:rat_type], :length => len
  end
  def rat_name_link(id, len=18)
    rat = Rat.where(rat_id: id).first
    link_to truncate(rat[:rat_name], :length => len), rats_show_path( :rat_id => id )
  end
  def rat_image(id, size=64)
    src = "rats/#{id}_#{size}.png"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("rat", id, size)
    end
    image_tag src, :class => "img-rounded ttp", :style => "margin: 2px", :title => Rat.rat_name(id) + "<br>" + Rat.rat_type(id)
  end
  def rat_image_tiny(id, size=32)
    src = "rats/#{id}_#{size}.png"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("rat", id, size)
    end
    link_to image_tag(src, :style => "height: 18px", :class => "img-rounded ttp", :title => Rat.rat_name(id) + "<br>" + Rat.rat_type(id) + "<br><b>Click to show Rat details!"), rats_show_path(:rat_id => id)
  end
  def rat_image_link(id, size=64)
    src = "rats/#{id}_#{size}.png"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("rat", id, size)
    end
    link_to image_tag(src, :class => "img-rounded ttp", :title => Rat.rat_name(id) + "<br>" + Rat.rat_type(id) + "<br><b>Click to show Rat details!"), rats_show_path(:rat_id => id)
  end
  def corp_image(id, size=64)
    src = "corps/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("corp", id, size)
    end
    image_tag(src, :class => "img-rounded")
  end
  def character_image(id, size=64)
    src = "characters/#{id}_#{size}.jpg" 
    char = Character.where(char_id: id).first
    if bear = char.bear
      src = "bears/bear#{bear}.gif"
    end
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    image_tag(src, :class => "img-rounded", :style => "height: #{size}px")
  end
  def corp_image_link(id, size=64)
    src = "corps/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("corp", id, size)
    end
    link_to image_tag(src, :class => "img-rounded ttp", :title => corp_name(id)), corp_profile_path( :corp_id => id )
  end
  def character_image_link(id, size=64)
    src = "characters/#{id}_#{size}.jpg"
    char = Character.where(char_id: id).first
    if bear = char.bear
      src = "bears/bear#{bear}.gif"
    end
    
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    link_to image_tag(src, :class => "img-rounded", :style => "height: #{size}px"), character_profile_path( :char_name => char.name )
  end
  def character_image_link_tiny(id, size=32)
    src = "characters/#{id}_#{size}.jpg"
    char = Character.where(char_id: id).first
    if bear = char.bear
      src = "bears/bear#{bear}.gif"
    end
    
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    link_to image_tag(src, :class => "img-rounded", :style => "height: 18px"), character_profile_path( :char_name => char.name )
  end
  def character_tick_link(id, tick, size=64)
    src = "characters/#{id}_#{size}.jpg"
    if ! Rails.application.assets.find_asset(src)
      src = ext_image("character", id, size)
    end
    link_to image_tag(src, :class => "img-rounded"), kills_log_path(:filter => { :_id => tick } )
  end
  def top_incursion(limit=5)
    return Incursion.top_incursion(limit)
  end
  def top_bounty(limit=5)
    return Bounty.top_bounty(limit)
  end
  def top_tax(limit=5)
    return Bounty.top_tax(limit)
  end
  def top_corp_bounty(limit=5)
    return Bounty.top_corp_bounty(limit)
  end
  def rat_bounty(id)
    bounty = Rat.where(rat_id: id).first[:bounty]
    return bounty
  end
  def top_incursion_this_month(limit=5)
    return Incursion.top_incursion_this_month(limit)
  end
  def top_incursion_10days(limit=5)
    return Incursion.top_incursion_days(10, limit)
  end
  def top_tax_this_month(limit=5)
    return Bounty.top_tax_this_month(limit)
  end
  def top_corp_bounty_this_month(limit=5)
    return Bounty.top_corp_bounty_this_month(limit)
  end
  def top_corp_bounty_10days(limit=5)
    return Bounty.top_corp_bounty_days(10, limit)
  end
  def top_tax_10days(limit=5)
    return Bounty.top_tax_days(10, limit)
  end
  def top_bounty_this_month(limit=5)
    return Bounty.top_bounty_this_month(limit)
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
  def top_kills_this_month(limit=5)
    return Bounty.top_kills_this_month(limit)
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
    dir = "Corporation" if type == "corp"
    dir = "Character" if type == "character"
    ext = "jpg" if type == "character"
    ext = "png" if type == "rat"
    ext = "png" if type == "corp"
    return "http://image.eveonline.com/#{dir}/#{id}_#{size}.#{ext}"
  end
end
