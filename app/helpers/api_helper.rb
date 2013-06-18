module ApiHelper
  def api_check(key, vcode)
    uri = URI.parse "https://api.eveonline.com/char/WalletJournal.xml.aspx?keyID=#{key_id}&vcode=#{vcode}&rowCount=1"
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    response = http.request(request)

    xml = Nokogiri::XML(response.body)

    error_message = xml.xpath("//error").children.to_s
    if error_message.empty?
      return true
    else
      flash[:error] = error_message
      return false
    end
  end
end
