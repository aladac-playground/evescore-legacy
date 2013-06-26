class ApiController < ApplicationController
  require 'net/http'
  def import
    if params[:char_id]
      char = Character.where(:char_id => params[:char_id]).first
      vcode = char[:vcode]
      key_id = char[:key]
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
            Bounty.create!(ts: ts, char_id: owner_id, bounty: amount.to_i)
          rescue Exception => e
            p e.message
          end
          reason.split(",").each do |entry|
            entry = entry.split(":")
            rat_id = entry[0]
            next if rat_id == "..."
            rat_amount = entry[1]
            bounty = Rat.where(rat_id: rat_id).first[:bounty]
            begin
              Kill.create!(ts: ts, char_id: owner_id, rat_id: rat_id, rat_amount: rat_amount, bounty: bounty)
            rescue Exception => e
              p e.message
            end
          end
        end
      end
    end
    redirect_to character_profile_path(:char_id => params[:char_id])
  end
  def import_all
    Character.all.each do |character|
      puts "Getting data for: #{character[:name]}"
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
            Bounty.create!(ts: ts, char_id: owner_id, bounty: amount.to_i)
          rescue Exception => e
            p e.message
          end
          reason.split(",").each do |entry|
            entry = entry.split(":")
            rat_id = entry[0]
            next if rat_id == "..."
            rat_amount = entry[1]
            bounty = Rat.where(rat_id: rat_id).first[:bounty]
            begin
              Kill.create!(ts: ts, char_id: owner_id, rat_id: rat_id, rat_amount: rat_amount, bounty: bounty)
            rescue Exception => e
              p e.message
            end
          end
        end
      end
    end
  end
  def verify
    @api_check = api_check(params[:key], params[:vcode])
    character_check(params[:key], params[:vcode])
    respond_to do |format|
      format.json { render json: @api_check }
    end
  end

  private

  def api_check(key, vcode)
    uri = URI.parse "https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=#{key}&vcode=#{vcode}&rowCount=1"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)
  
    xml = Nokogiri::XML(response.body)

    error_message = xml.xpath("//error").children.to_s
    if response.code != "200"
      error_message = "API Server Error: " + response.code.to_s + " " + response.body
    end
    if error_message.empty?
      character = character_check(key, vcode)
      return { valid: true, message: error_message, character: character }
    else
      return { valid: false, message: error_message }
    end
  end

  def character_check(key, vcode)
    uri = URI.parse "https://api.eveonline.com/account/Characters.xml.aspx?keyID=#{key}&vcode=#{vcode}"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    xml = Nokogiri::XML(response.body)

    error_message = xml.xpath("//error").children.to_s
    if error_message.empty?
      doc = xml.xpath("//row").first
      char_id = doc['characterID']
      name = doc['name']
      return { name: name, char_id: char_id }
    else
      return nil
    end
  end
end
