require "net/http"
require "crack"
require "yaml"

METHODS = YAML.load_file("config/initializers/methods.yml")
API_URL = "https://api.eveonline.com"

# Get instance vars as Hash
class Object
  def instance_variables_hash
    Hash[instance_variables.map { |name| [name, instance_variable_get(name)] } ]
  end
end

# Check the numericality of String
class String
  def numeric?
    Float(self) != nil rescue false
  end
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end
end

class Hash
  def rubify
    Hash[self.map {|k, v| [k.underscore.to_sym, v]} ]
  end
end

module Eve
  class Util
    def self.fetch(method, args)
      url = url method
    end
    def self.url(method)
      url = API_URL + METHODS[method][:path]
    end
  end
  class Api
    attr_accessor :key_id
    attr_accessor :vcode
    attr_accessor :character_id
    attr_accessor :names
    attr_accessor :ids
    attr_accessor :debug
    attr_accessor :row_count
    def method_missing(meth, *args)
      if METHODS[meth.to_sym]
        vars = instance_variables_hash
        if vars.empty? == false
          query_string = "?"
          len = vars.length
          i = 0
          vars.each_pair do |name, value|
            i += 1
            name = name.to_s.gsub(/^@/,"")
            query_string += name.camel_case + "=" + value.to_s
            if i < len
              query_string += "&"
            end
          end
        end
          
        if query_string 
          url = API_URL + METHODS[meth.to_sym][:path] + query_string
        else
          url = API_URL + METHODS[meth.to_sym][:path]
        end
        p url if self.debug == true
        uri = URI.parse url
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        
        request = Net::HTTP::Get.new(uri.request_uri)
        
        response = http.request(request)
        xml_hash = Crack::XML.parse(response.body)
      end
    end
  end
end