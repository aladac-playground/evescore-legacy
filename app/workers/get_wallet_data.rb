class GetWalletData
  include Sidekiq::Worker

  def perform( name, count )
    Character.all.each do |character|
      uri = URI.parse "https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=#{key}&vcode=#{vcode}&rowCount=1"
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      xml = Nokogiri::XML(response.body)

      error_message = xml.xpath("//error").children.to_s
    end
  end
end
