class News
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  
  def self.fresh
    order_by(:updated_at.desc).first
  end
end
