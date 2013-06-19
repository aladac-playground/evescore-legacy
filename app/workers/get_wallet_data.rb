class GetWalletData
  include Sidekiq::Worker

  def perform(name, count)
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
            DB[:bounty].insert([:ts, :char_id, :bounty],[ts, owner_id, amount.to_f])
          rescue Exception => e
            if e.message !~ /Mysql2::Error: Duplicate entry/
              p e.message
            end
          end
          reason.split(",").each do |entry|
            entry = entry.split(":")
            rat_id = entry[0]
            rat_amount = entry[1]
            begin
              DB[:kills].insert([:ts, :ref_id, :char_id, :rat_id, :rat_amount, :bounty], [ts, ref_id, owner_id, rat_id, rat_amount, amount])
            rescue Exception => e
              if e.message !~ /Mysql2::Error: Duplicate entry/
                p e.message
              end
            end
          end
        end
      end
    end
  end
end
