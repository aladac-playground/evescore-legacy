class Array
  def wallet_import
    self.each do |row|
      if row['refTypeID'] == "85"
        reason = row['reason']
        amount = row['amount'].to_i
        owner_name = row['ownerName2']
        owner_id = row['ownerID2']
        ref_id = row['refID']
        ts = row['date']
        tax = row['taxAmount'].to_i
        corp_id = Character.where(char_id: owner_id).first.corp_id
        begin
          b = Bounty.new(ts: ts, char_id: owner_id, bounty: ( amount * 100 ).to_i, tax: (tax * 100).to_i, corp_id: corp_id)
          r = b.save
          next if r == false
        rescue Exception => e
          p e.message
        end
        reason.split(",").each do |entry|
          entry = entry.split(":")
          rat_id = entry[0]
          next if rat_id == "..."
          rat_amount = entry[1]
          begin
            b.kills.create!(rat_id: rat_id, rat_amount: rat_amount)
          rescue Exception => e
            p e.message
          end
        end
      end
    end
  end
end
    
