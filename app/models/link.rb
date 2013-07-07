class Link
  include Mongoid::Document
  field :ts, type: Time
  field :op_start, type: Time
  field :op_end, type: Time
  field :char_id, type: Integer
  field :char_name, type: String
  embeds_many :characters
  
  def self.links(id)
    where(char_id: id).count
  end
end
