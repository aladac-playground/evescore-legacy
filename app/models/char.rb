class Char < ActiveRecord::Base
  belongs_to :corp
  belongs_to :user
  belongs_to :key
  has_many :wallet_records
  has_many :kills
  
  def losses
    url = "https://zkillboard.com/api/losses/no-items/no-attackers/characterID/#{self.id}/"
  end
  
  def self.import(data)
    data=data.inject({}){|row,(k,v)| row[k.to_sym] = v; row}
    
    if data[:char_id] and data[:name] and data[:corp_id] and data[:corp_name]
      # check if corp is allied
      allied = Allied.where(corp_id: data[:corp_id]).first      
      if allied
        alliance_id = allied.alliance_id
        alliance_name = Alliance.find(alliance_id).name
      else
        alliance_name = nil
        alliance_id = nil
      end
      
      # check if corp exists
      corp = Corp.where(id: data[:corp_id]).first
      if ! corp
        corp = Corp.create(id: data[:corp_id], name: data[:corp_name], alliance_id: alliance_id, alliance_name: alliance_name)
      end
      
      # check if char exists
      char = Char.where(id: data[:char_id]).first
      
      if char
        char.update_attributes(id: data[:char_id], name: data[:name], corp_name: data[:corp_name], corp_id: data[:corp_id], alliance_name: alliance_name, alliance_id: alliance_id)
      else
        Char.create(id: data[:char_id], name: data[:name], corp_name: data[:corp_name], corp_id: data[:corp_id], alliance_name: alliance_name, alliance_id: alliance_id)
      end
    end
  end
  
  def wallet_import(rows=50)
    api = self.key
    if api 
      api = api.api
      api.row_count = rows
      api.character_id = self.id
      begin
        api_journal = api.wallet_journal["eveapi"]["result"]["rowset"]["row"]
        if api_journal and api_journal.class == Array
          api_journal.wallet_import
        end
      rescue
        nil
      end
    else
      nil
    end
  end
  def bounty
    self.wallet_records.bounty
  end
  def income
    self.wallet_records.sum(:amount)
  end
  
  def top_tick(t=nil)
    case t
    when :this_month
      tick = wallet_records.this_month.order("amount desc").first
      (tick.amount or 0) if tick
    when :last_ten_days 
      tick = wallet_records.last_ten_days.order("amount desc").first
      (tick.amount or 0) if tick
    else
      tick = wallet_records.order("amount desc").first
      (tick.amount or 0) if tick
    end
  end    
  def bounty_rank
    ranks = {}
    i=0
    WalletRecord.top_bounty.each do |char|
      i+=1
      tmp = { char.id => i }
      ranks.merge! tmp
    end
    ranks[self.id]
  end
end
