require_relative "config/boot"
require_relative "config/environment"

s=SigType.all

out=[]

f=File.new("sig_types.yml","w")

s.each do |sig|
	out.push sig
end

f.puts out.to_yaml
f.close
