class ApiController < ApplicationController
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
