require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "config/boot"
require_relative "config/environment"
 
# Rat.all.each do |rat|
#   c = rat.rat_attributes.count
#   if c == 0
#     puts rat.rat_name, rat.rat_id
#   end
# end

map = %Q|
  function() {
    emit(this.rat_name, this.rat_attributes["name"] );
  }
|

reduce = %Q{
  function(name, value ) {
    if ( value == "warpScrambleRange" ) {
      return value;
    } 
  }
}

pp Rat.all.map_reduce(map, reduce).out(inline: true).to_a
