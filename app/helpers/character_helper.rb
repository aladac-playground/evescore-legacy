module CharacterHelper
  def cache_key
    count = Bounty.count
    badges = Character.where(char_id: @char_id).first.badges
    if badges
      badge_count = badges.count
    end
    key = params[:controller].to_s + params[:action].to_s + count.to_s
    key += badge_count.to_s
    key += params[:char_id].to_s if params[:char_id]
    key += params[:char_name].to_s if params[:char_name]
    key += params[:page].to_s if params[:page]
    key += params[:corp_id].to_s if params[:corp_id]
    key += params[:filter].to_s if params[:filter]
    return key
  end
  
  def build_date(day)
    year = day["_id"]["year"].to_i
    month = day["_id"]["month"].to_i
    day = day["_id"]["day"].to_i
    ts = Time.mktime(year, month, day)
    date = ts.strftime("%b-%-d")
    return date
  end
  def total_kills
    Bounty.total_kills(@char_id.to_i)
  end
  def total_bounty
    Bounty.total_bounty(@char_id)
  end
  def top_tick
    Bounty.top_tick(@char_id.to_i)
  end
  def avg_tick
    Bounty.avg_tick(@char_id.to_i)
  end
  def top_daily
    Bounty.top_daily(@char_id.to_i)
  end
  def bounty_this_month
    Bounty.bounty_this_month(@char_id.to_i)
  end
  def kills_this_month
    Bounty.kills_this_month(@char_id.to_i)
  end
end
