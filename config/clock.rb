require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class GetWalletData
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      Log.info "STARTED Getting data for: #{character[:name]}"
      vcode = character[:vcode]
      key_id = character[:key]
      uri = URI.parse "https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=#{key_id}&vcode=#{vcode}&rowCount=1000"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      xml = Nokogiri::XML(response.body)

      xml.xpath("//row").each do |row|
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
      Log.info "FINISHED Getting data for: #{character[:name]}"  
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting data for all, took: #{duration} seconds"
  end
end

class GetCharacterImages
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      [ "32", "64", "128", "256"].each do |size|
        next if Rails.application.assets.find_asset("characters/#{character[:char_id]}_#{size}.jpg")
        
        Log.info "STARTED Getting image size: #{size} for: #{character[:name]}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Character/#{character[:char_id]}_#{size}.jpg")
            open("./app/assets/images/characters/#{character[:char_id]}_#{size}.jpg", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{character[:name]}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all characters, took: #{duration} seconds"
  end
end

class GetRatImages
  def self.perform
    start = Time.now.to_i
    Bounty.unique_rats.each do |rat|
      [ "32", "64" ].each do |size|
        next if Rails.application.assets.find_asset("rats/#{rat["_id"]}_#{size}.png")
        Log.info "STARTED Getting image size: #{size} for: #{Rat.where(:rat_id => rat["_id"]).first.rat_name}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Type/#{rat["_id"]}_#{size}.png")
            open("./app/assets/images/rats/#{rat["_id"]}_#{size}.png", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{Rat.where(:rat_id => rat["_id"]).first.rat_name}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all rats, took: #{duration} seconds"
  end
end
 
module Clockwork
  every 5.minutes, 'get_score' do
    GetWalletData.perform
    # GetCharacterImages.perform
    # GetRatImages.perform
  end
end
