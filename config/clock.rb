require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class GetWalletData
  def self.perform
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
            b = Bounty.new(ts: ts, char_id: owner_id, bounty: ( amount * 100 ).to_i)
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
end
 
module Clockwork
  every 5.minutes, 'get_score' do
    GetWalletData.perform
  end
end
