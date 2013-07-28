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
  field :bear, type: Integer
  # field :key, type: String
  # field :vcode, type: String
  field :last_visit, type: Time
  index({  char_id: 1 }, { unique: true, drop_dups: true })
  index({ name: 1 })
  index({ name: -1 })
  has_many :character_badges
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
  def kills
    Bounty.total_kills(self.char_id)
  end
  def top_rats(limit=10)
    Bounty.rats(self.char_id)
  end
  def award_badge(name)
    badge = self.character_badges.new
    id = Badge.where(name: name).first.id
    badge.badge_id = id
    badge.save
  end
  def total_bounty
    Bounty.total_bounty(self.char_id)
  end
  def badges
    a = Array.new
    self.character_badges.each do |badge|
      a.push badge.badge
    end
    a
  end
  def kills_by_rat_name(name)
    rat_ids = Array.new
    Rat.any_of(rat_name: /#{name}/ ).to_a.each do |rat|
      rat_ids.push rat.rat_id
    end
    count = 0
    Bounty.collection.aggregate({ "$match" => { "char_id" => self.char_id }}, { "$unwind" => "$kills" } ).to_a.each do |row|
      # "kills"=>{"_id"=>"51e06424ade21b90a700005f", "rat_id"=>23319, "rat_amount"=>2}
      if rat_ids.include? row["kills"]["rat_id"]
        count += row["kills"]["rat_amount"]
      end
    end
    count
  end
  def kills_by_rat_type(type)
    rat_ids = Array.new
    Rat.any_of(rat_type: /#{type}/ ).to_a.each do |rat|
      rat_ids.push rat.rat_id
    end
    count = 0
    Bounty.collection.aggregate({ "$match" => { "char_id" => self.char_id }}, { "$unwind" => "$kills" } ).to_a.each do |row|
      # "kills"=>{"_id"=>"51e06424ade21b90a700005f", "rat_id"=>23319, "rat_amount"=>2}
      if rat_ids.include? row["kills"]["rat_id"]
        count += row["kills"]["rat_amount"]
      end
    end
    count
  end
end
