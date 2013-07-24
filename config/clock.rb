require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class CheckCharacters
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      Log.info "STARTED Updating character data for: #{character[:name]}"
      key = character.key
      api = Eve::Api.new(key[:key_id], key[:vcode])    
      api.char_id = character.char_id
      chars = api.characters
      next if chars.nil?
      char = chars.first
      corp = Corp.create!(corp_id: char[:corp_id], name: char[:corp_name])
      character.corp_id = corp.corp_id
      character.corp_name = corp.name
      character.save!
      Log.info "FINISHED Updating character data for: #{character[:name]}"  
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Updating character data for all, took: #{duration} seconds"
  end
end

class AwardBadges
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      Log.info "STARTED Badge awarding for: #{character[:name]}"
      # "Bring me 1000 rat tails!"
      # Combat badge earned by the pilots who destroyed 1000 pirate vessels
      if character.kills >= 1000
        character.award_badge("Bring me 1000 rat tails!")
      end
      
      # "You Guristas scum..."
      # "You are fighting the good fight and in that fight you sunk 1000 Guristas ships"
      if character.kills_by_rat_type("Guristas") >= 1000
        character.award_badge("You Guristas scum...")
      end
      
      # "Found the Water Chip!"
      # "Awarded for killing a Deadspace Overseer.<br><i>''You're a hero... and you have to leave.''</i>"
      if character.kills_by_rat_type("Overseer") >= 1
        character.award_badge("Found the Water Chip!")
      end
      
      # "You need to call Tyrone!"
      if character.total_bounty >= 100000000
        character.award_badge("You need to call Tyrone!")
      end
      
      # "Triple your ISK... honestly"
      if character.total_bounty >= 300000000
        character.award_badge("Triple your ISK... honestly")
      end
      
      # "Eastbound and down..."
      if character.kills_by_rat_type("Hauler") >= 1
        character.award_badge("Eastbound and down...")
      end
      
      Log.info "FINISHED Badge awarding for: #{character[:name]}"

    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Badge awarding for all, took: #{duration} seconds"
  end
end


class GetWalletData
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      Log.info "STARTED Getting data for: #{character[:name]}"
      key = character.key
      api = Eve::Api.new(key[:key_id], key[:vcode])    
      api.rows = 3000
      wallet = api.wallet_journal
      wallet.wallet_import
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
        rat_name = Rat.where(:rat_id => rat["_id"]).first
        next if rat_name.nil?
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

class GetCorpImages
  def self.perform
    start = Time.now.to_i
    Corp.each do |corp|
      [ "32", "64" ].each do |size|
        next if Rails.application.assets.find_asset("corps/#{corp.corp_id}_#{size}.png")
        Log.info "STARTED Getting image size: #{size} for: #{corp.name}"  
        Net::HTTP.start("image.eveonline.com") do |http|
            resp = http.get("/Corporation/#{corp.corp_id}_#{size}.png")
            open("./app/assets/images/corps/#{corp.corp_id}_#{size}.png", "wb") do |file|
                file.write(resp.body)
            end
        end
        Log.info "FINISHED Getting image size: #{size} for: #{corp.name}"  
      end
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Getting images for all corps, took: #{duration} seconds"
  end
end
 
module Clockwork
  every 15.minutes, 'get_score' do
    # CheckCharacters.perform
    GetWalletData.perform
    # AwardBadges.perform
    # GetCorpImages.perform
    # GetCharacterImages.perform
    # GetRatImages.perform
  end
end
