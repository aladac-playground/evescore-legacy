namespace :import do
  desc "Import Bounty wallet data"
  task :bounty => :environment do
    session = Moped::Session.new([ "127.0.0.1:27017", "127.0.0.1:27018", "127.0.0.1:27019" ])
    session.use :evescore_development
    
    bounties = session[:bounties]
  
    records = bounties.find.count
    
  
    pb = ProgressBar.create(:title => "Migrating Bounty Records", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 )
    bounties.find.each do |bounty|
      #  => #<Bounty _id: 51cbfcf4d92a031cfc00019a, ts: 2013-06-03 16:43:01 UTC, char_id: 90504476, corp_id: 98119753, tax: nil, bounty: 1333300>
      #  => WalletRecord(id: integer, ts: datetime, char_name: string, corp_name: string, alliance_name: string, ref_type_id: integer, amount: integer, tax: integer, char_id: integer, corp_id: integer, alliance_id: integer, created_at: datetime, updated_at: datetime, user_id: integer, anon: boolean)
      # old kill    {"_id"=>"51d9a4a3072107e7600014f6", "rat_id"=>24014, "rat_amount"=>3},
      # New kill 
      #  => Kill(id: integer, ts: datetime, rat_name: string, rat_type: string, rat_amount: integer, char_name: string, corp_name: string, alliance_name: string, char_id: integer, corp_id: integer, alliance_id: integer, wallet_record_id: integer, created_at: datetime, updated_at: datetime, rat_id: integer, user_id: integer, anon: boolean)
      # pp bounty
      char_id = bounty["char_id"]
      tax = bounty["tax"]
      if tax.nil? 
        tax = 0
      end
      amount = bounty["bounty"]
      ts = bounty["ts"]
      # p "char = Char.find(#{char_id})"
      begin
        char = Char.find(char_id)
      rescue
        next
      end
      corp = char.corp
      next if corp.nil?
      anon = char.anon
    
      w=WalletRecord.new(ts: ts, char_name: char.name, corp_name: corp.name, alliance_name: char.alliance_name, ref_type_id: 85, amount: amount,
         tax: tax, char_id: char_id, corp_id: corp.id, alliance_id: corp.alliance_id, anon: anon)
      w.save
    
      bounty["kills"].each do |kill|
        rat = Rat.find(kill["rat_id"])
        w.kills.new(ts: ts, rat_name: rat.name, rat_type: rat.rat_type, rat_amount: kill["rat_amount"], char_name: char.name, corp_name: corp.name, 
          alliance_name: char.alliance_name, char_id: char.id, corp_id: corp.id, alliance_id: corp.alliance_id, rat_id: rat.id, anon: anon 
        )
        w.save
      end
      pb.increment     
    end
  end
end