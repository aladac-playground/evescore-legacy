require "nokogiri"
require "net/http"

API_URL = "https://api.eveonline.com"
METHOD_URLS = {
  :api_key_info => "/account/APIKeyInfo.xml.aspx",
  :characters => "/account/Characters.xml.aspx",
  :wallet_journal => "/char/WalletJournal.xml.aspx"
}
VAR_MAP = {
  :@key => "keyID",
  :@vcode => "vCode",
  :@rows => "rowCount"
}

# Get instance vars as Hash
class Object
  def instance_variables_hash
    Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
  end
end

module Eve
  class Util
    def self.fetch(method, args)
      url = build_query method, args
      uri = URI.parse url
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)
      doc = Nokogiri::XML::Document.parse(response.body)
    end
    def self.build_query(method, args)
      url = API_URL + METHOD_URLS[method]
      
      query_string = "?"
      len = args.length
      i = 0
      args.each_pair do |name, value|
        i += 1
        query_string += VAR_MAP[name] + "=" + value
        if i < len
          query_string += "&"
        end
      end
      return url + query_string
    end
  end
  class Api
    attr_reader :key
    attr_reader :vcode
    
    def initialize(key, vcode, rows=50)
      @key = key
      @vcode = vcode
      @rows = rows.to_s
    end
    
    def tst
      Util.fetch( :characters, self.instance_variables_hash)
    end
    
    # ================
    # = API Key Info =
    # ================
    
    def api_key_info
      doc = Util.fetch( __method__, self.instance_variables_hash )
      key = doc.xpath("//key")
      key_info = Hash.new
      if ! key.empty?
        key_info = {
          key_id: @key,
          vcode: @vcode,
          type: key.attr("type").value,
          access_mask: key.attr("accessMask").value,
          expires: key.attr("expires").value
        }
      else
        nil
      end      
    end
    
    # ==============
    # = Characters =
    # ==============
    
    def characters
      doc = Util.fetch( __method__, self.instance_variables_hash )
      rows = doc.xpath("//row")
      characters = Array.new
      rows.each do |row|
        if row
          character = {
            name: row.attr("name"),
            char_id: row.attr("characterID").to_i,
            corp_id: row.attr("corporationID").to_i,
            corp_name: row.attr("corporationName")
          }
          characters.push character
        end
      end
      
      if characters.empty?
        return nil
      else
        return characters
      end
    end
    
    # ==================
    # = Wallet Journal =
    # ==================
    
    
    def wallet_journal
      doc = Util.fetch( __method__, self.instance_variables_hash )
      rows = doc.xpath("//row")
      wallet = Array.new
      rows.each do |row|
        output = Hash.new
        row.attributes.each_pair do |attr, inside|
          output.merge!( { attr => inside.value } )
        end
        wallet.push output
      end
      wallet
    end
    
  end
end
    
