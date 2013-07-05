module CharacterHelper
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
end
