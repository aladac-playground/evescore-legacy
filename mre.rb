require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "config/boot"
require_relative "config/environment"
 
 
map = %Q|
  function() {
    for (index in this.kills) {
        emit(this.kills[index].rat_id, this.kills[index].rat_amount );
    }
  }
|

reduce = %Q|
  function(key, values) {
    var count = 0;

    for (index in values) {
        count += values[index];
    }

    return count;
  }
|

a = Bounty.map_reduce(map, reduce).out(replace: "rat_kills")
pp a.first