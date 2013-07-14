require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "config/boot"
require_relative "config/environment"
 
Bounty.unique_rats.each do |r|
  rat = Rat.where(rat_id: r["_id"]).first
  puts rat.rat_name + "\t" + rat.rat_type
end