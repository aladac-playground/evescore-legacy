module ApplicationHelper
  def character_name(id)
    character = Character.where(char_id: id).first
    return character[:name]
  end
end
