module CharacterHelper
  def build_date(id)
    date = id["year"].to_s + "-" + id["month"].to_s + "-" + id["day"].to_s
    return date
  end
end
