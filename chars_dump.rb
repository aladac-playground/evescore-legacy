require_relative "config/boot"
require_relative "config/environment"
 
r = []
Character.each do |char|
  if char.bear
    pub = false
  else
    pub = true
  end
  tmp = { id: char.char_id, name: char.name, corp_id: char.corp_id, pub: pub, corp_name: char.corp_name  }
  r.push tmp
end

puts r.to_yaml

