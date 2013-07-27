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
      if character.corp_id != 0
        corp = Corp.create!(corp_id: char[:corp_id], name: char[:corp_name]) 
        character.corp_id = corp.corp_id
        character.corp_name = corp.name
      end
      character.save!
      Log.info "FINISHED Updating character data for: #{character[:name]}"  
    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Updating character data for all, took: #{duration} seconds"
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
 
module Clockwork
  every 15.minutes, 'get_score' do
    CheckCharacters.perform
    GetWalletData.perform
  end
end
