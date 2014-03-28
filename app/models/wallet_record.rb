class WalletRecord < ActiveRecord::Base
  belongs_to :char
  belongs_to :corp
  belongs_to :user
  belongs_to :alliance
  has_many :kills, dependent: :destroy
  validates_uniqueness_of :ts, scope: [ :char_id, :ref_type_id ]
  
  scope :sort_by_sum_amount_desc, -> {
    order("sum(amount) desc")
  }
  scope :sort_by_sum_amount_asc, -> {
    order("sum(amount) asc")
  }
    
  # default_scope {
  #   order("ts desc")
  # }
  scope :non_anon, -> {
    where("anon <> 1 or anon is null")
  }
  scope :top_incursion, -> {
    non_anon
    .incursion
    .select("char_name as name, sum(amount) as amount, char_id as id")
    .group(:char_id)
    .order("sum(amount) desc")
  }
  scope :top_bounty, -> {
    non_anon
    .bounty
    .select("char_name as name, sum(amount) as amount, char_id as id")
    .group(:char_id)
    .where("amount > 0")
    .order("sum(amount) desc")
  }
  scope :allied, -> {
    where("alliance_id is not null")
  }
  scope :top_income, -> {
    non_anon
    .select("cast(ts as date) as date, char_id as id, char_name as name, sum(amount) as sum_amount, sum(amount) as amount, sum(tax) as tax")
    .where("amount > 0")
    .group(:char_id)
    .order("sum(amount) desc")
  }
  scope :top_ticks, -> {
    non_anon
    .select("char_id as id, char_name as name, amount as amount")
    .group(:char_id)
    .order("amount desc")
  }
  scope :bounty, -> {
    where(ref_type_id: 85)
  }
  scope :mission_all, -> {
    where(ref_type_id: [ 33, 34 ] )
  }
  scope :mission_time, -> {
    where(ref_type_id: 34 )
  }
  scope :mission, -> {
    where(ref_type_id: 33 )
  }
  scope :incursion, -> {
    where(ref_type_id: 99)
  }
  scope :this_month, -> {
    where("ts >= '#{Time.now.beginning_of_month}'")
  }
  scope :last_ten_days, -> {
    where("ts >= '#{Time.now - 10.days}'")
  }
  scope :alliance, -> {
    non_anon
    .select("alliance_id as id, alliance_name as name, sum(amount) as amount")
    .group(:alliance_id)
    .order("sum(amount) desc")
  }
  scope :corp, -> {
    non_anon
    .select("corp_id as id, corp_name as name, sum(amount) as amount")
    .group(:corp_id)
    .order("sum(amount) desc")
  }
  scope :recent, -> {
    non_anon
    .order("ts desc")
    .limit(10)
  }
  
  def self.parse(data)
      #  {"date"=>"2014-03-15 21:45:54",
    # "refID"=>"9167492883",
    # "refTypeID"=>"34",
    # "ownerName1"=>"Kiljavas Yaskasen",
    # "ownerID1"=>"3010176",
    # "ownerName2"=>"Adrian Dent",
    # "ownerID2"=>"810699209",
    # "argName1"=>"Kiljavas Yaskasen",
    # "argID1"=>"3010176",
    # "amount"=>"1530800.00",
    # "balance"=>"7590542961.71",
    # "reason"=>"",
    # "taxReceiverID"=>"1000009",
    # "taxAmount"=>"189200.00",
    # "owner1TypeID"=>"1375",
    # "owner2TypeID"=>"1375"}
    # => ["id", "ts", "char_name", "corp_name", "alliance_name", "ref_type_id", "amount", "tax", "char_id", "corp_id", "alliance_id", "created_at", "updated_at", "user_id", "anon"]
    char = Char.find(data["ownerID2"].to_i)
    corp = Corp.where(id: char.corp_id).first
    if ! corp
      allied = Allied.where(corp_id: char.corp_id).first
      if allied
        alliance_id = allied.alliance_id
        alliance_name = Alliance.find(alliance_id).name
      else
        alliance_id = nil
        alliance_name = nil
      end
      Corp.create(name: char.corp_name, id: char.corp_id, alliance_id: alliance_id, alliance_name: alliance_name)
    end
    WalletRecord.create(
      ts: Time.parse(data["date"]), 
      char_name: char.name, 
      corp_name: char.corp_name, 
      alliance_name: char.alliance_name,
      ref_type_id: data["refTypeID"],
      amount: data["amount"].to_f * 100,
      tax: data["taxAmount"].to_f * 100,
      char_id: char.id,
      corp_id: char.corp_id,
      alliance_id: char.alliance_id,
      user_id: char.user_id,
      anon: char.anon
    )    
  end
  def self.parse_reason(data)
    # {"date"=>"2014-03-15 19:11:27",
    #   "refID"=>"9166617218",
    #   "refTypeID"=>"85",
    #   "ownerName1"=>"CONCORD",
    #   "ownerID1"=>"1000125",
    #   "ownerName2"=>"Adrian Dent",
    #   "ownerID2"=>"810699209",
    #   "argName1"=>"Tvink",
    #   "argID1"=>"30002073",
    #   "amount"=>"3185087.50",
    #   "balance"=>"7561079960.73",
    #   "reason"=>
    #    "13113:2,16567:3,17058:2,17582:4,17583:2,17607:2,24002:2,24019:4,24086:3,24155:1,",
    #   "taxReceiverID"=>"1000009",
    #   "taxAmount"=>"393662.50",
    #   "owner1TypeID"=>"2",
    #   "owner2TypeID"=>"1375"}
    # => ["id", "ts", "rat_name", "rat_type", "rat_amount", "char_name", "corp_name", "alliance_name", "char_id", "corp_id", "alliance_id", "wallet_record_id", "created_at", "updated_at", "rat_id", "user_id", "anon"]
    reason = data["reason"]
    rats = {}
    reason.split(",").each do |row|
      next if row == "..."
      next if row.empty?
      next if row.nil?
      rat_id, rat_amount = row.split(":")
      tmp = { rat_id.to_i => rat_amount.to_i }
      rats.merge! tmp
    end
    rats
  end  
end

