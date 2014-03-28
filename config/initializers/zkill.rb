require "net/http"

module Zkill
  class Util
    def self.fetch(url)
      uri = URI.parse url
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      response.body
    end
  end
  class Api
    attr_accessor :char_id
    
    def initialize(char_id)
      @char_id = char_id
    end    
    
    def losses
      url = "https://zkillboard.com/api/losses/startTime/200301010000/no-attackers/characterID/#{self.char_id}/"
      body = Util.fetch(url)
      data = JSON.parse(body)
      p data.last
      amount = 0
      data.each do |kill|
        if kill["zkb"]
          if kill["zkb"]["totalValue"]
            amount += kill["zkb"]["totalValue"]
          end
        end
      end
      amount
    end
  end
end
    
    
