class Character
  include Mongoid::Document
  # validates :key, :presence => true, :numericality => true, :length => { :is => 7 }
  # validates :vcode, :presence => true, :length => { :is => 64 }
  validates :char_id, :presence => true, :uniqueness => { :message => "Character already in use!"}
  validates :name, :presence => true
  field :char_id, type: Integer
  field :name, type: String
  field :corp_id, type: Integer
  field :corp_name, type: String
  # field :key, type: String
  # field :vcode, type: String
  field :last_visit, type: Time
  index({  char_id: 1 }, { unique: true, drop_dups: true })
  def self.json
    @characters = Array.new
    Character.all.each do |char|
      @characters.push char.name
    end
    return @characters.to_json
  end
  belongs_to :key
  belongs_to :corp, primary_key: :corp_id
  
  def daily(limit=90)
    Bounty.daily(self.char_id, limit)
  end
  def top_rats(limit=10)
    Bounty.rats(self.char_id)
  end
end
