class ApiController < ApplicationController
  def import
    char = Character.where(char_id: params[:char_id]).first
    key = char.key
    api = Eve::Api.new(key[:key_id], key[:vcode])    
    wallet = api.wallet_journal
    wallet.each do |row|
      if row['refTypeID'] == "85"
        reason = row['reason']
        amount = row['amount'].to_i
        owner_name = row['ownerName2']
        owner_id = row['ownerID2']
        ref_id = row['refID']
        ts = row['date']
        begin
          b = Bounty.new(ts: ts, char_id: owner_id, bounty: ( amount * 100 ).to_i)
          r = b.save
          next if r == false
          DebugLog.info("Character: #{character[:name]}, ID: #{character[:char_id]}, Bounty: #{amount}")
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
    redirect_to character_profile_path(:char_id => params[:char_id])
  end
  def verify
    api = Eve::Api.new(params[:key], params[:vcode])
    characters = api.characters
    if characters
      character = characters.first
      valid = true
    else
      valid = false
    end
    @verify = { valid: valid, character: character }
    respond_to do |format|
      format.json { render json: @verify }
    end
  end
end
