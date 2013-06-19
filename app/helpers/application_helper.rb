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
end
