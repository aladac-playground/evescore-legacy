require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class GenGraphs
  def self.perform
    start = Time.now.to_i
    
    # Kills faction shares
    
    size = "460x130"
    
    factions = {
      "Guristas Pirates" => "Guristas",
      "Sansha's Nation" => "Sansha's Nation",
      "Blood Raiders" => "Blood Raiders",
      "Serpentis Corporation" => "Serpentis",
      "Angel Cartel" => "Angel Cartel",
      "Rouge Drones" => "Drone"
    }
    
    labels = []
    data = []
    factions.each_pair do |faction, search|
      labels.push faction
      data.push Bounty.kills_by_rat_type(search)
    end
    
    total = data.inject{ |sum,x| sum +x }
    
    i=0
    labels.each do |l|
      percent = data[i].to_f / total * 100.0
      labels[i] = l + " - " + sprintf("%.f", percent) + " %"
      i+=1
    end 
    
    chart = Gchart.pie(:labels => labels, :data => data, :size => size, :bg => "272b30" )
    
    Graph.create(title: "Kills share by faction", data: chart )

    # Kills by ship type
    
    ships = {
      "Frigate" => "Frigate",
      "Destroyer" => "Destroyer",
      "Cruiser" => " Cruiser",
      "BattleCruiser" => "BattleCruiser",
      "Battleship" => "Battleship"
    }
    
    labels = []
    data = []
    ships.each_pair do |ship, search|
      labels.push ship
      data.push Bounty.kills_by_rat_type(search)
    end
    
    total = data.inject{ |sum,x| sum +x }
    
    i=0
    labels.each do |l|
      percent = data[i].to_f / total * 100.0
      labels[i] = l + " - " + sprintf("%.f", percent) + " %"
      i+=1
    end 
    
    chart = Gchart.pie(:labels => labels, :data => data, :size => size, :bg => "272b30" )
    
    Graph.create(title: "Kills share by ship type", data: chart )
    
    
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Updating graph data for all, took: #{duration} seconds"
  end
end
 
module Clockwork
  every 20.minutes, 'get_score' do
    GenGraphs.perform
  end
end
