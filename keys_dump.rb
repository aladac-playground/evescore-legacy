require_relative "config/boot"
require_relative "config/environment"
 
r = []

Key.each do |key|
  tmp = { id: key.key_id, vcode: key.vcode }
  r.push tmp
end

puts r.to_yaml
