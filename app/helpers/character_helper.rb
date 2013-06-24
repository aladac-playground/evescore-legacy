module CharacterHelper
  def build_date(day)
    year = day["_id"]["year"].to_i
    month = day["_id"]["month"].to_i
    day = day["_id"]["day"].to_i
    p year.class
    p month.class
    p day.class
    ts = Time.mktime(year, month, day)
    date = ts.strftime("%b-%-d")
    return date
  end
end
