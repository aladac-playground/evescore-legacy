require "logger"
Log=Logger.new(STDERR)
DebugLog=Logger.new("./log/bounty.log")

require_relative "../config/boot"
require_relative "../config/environment"
 
require 'clockwork'
require 'net/http'

class AwardBadges
  def self.perform
    start = Time.now.to_i
    Character.all.each do |character|
      Log.info "STARTED Badge awarding for: #{character[:name]}"
      # "Bring me 1000 rat tails!"
      # Combat badge earned by the pilots who destroyed 1000 pirate vessels
      if character.has_badge?("Bring me 1000 rat tails!") == false
        if character.kills >= 1000
          character.award_badge("Bring me 1000 rat tails!")
        end
      end
      
      # "On with the race"
      if character.has_badge?("On with the race") == false
        if character.kills >= 2000
          character.award_badge("On with the race")
        end
      end
      
      # "You Guristas scum..."
      # "You are fighting the good fight and in that fight you sunk 1000 Guristas ships"
      if character.has_badge?("You Guristas scum...") == false
        if character.kills_by_rat_type("Guristas") >= 1000
          character.award_badge("You Guristas scum...")
        end
      end
      
      # "Scaring the nation..."
      if character.has_badge?("Scaring the nation...") == false
        if character.kills_by_rat_type("Sansha's") >= 1000
          character.award_badge("Scaring the nation...")
        end
      end     
      
      # "With blood and rage of crimson red..."
      if character.has_badge?("With blood and rage of crimson red...") == false
        if character.kills_by_rat_type("Blood") >= 1000
          character.award_badge("With blood and rage of crimson red...")
        end
      end           
      
      # "Found the Water Chip!"
      # "Awarded for killing a Deadspace Overseer.<br><i>''You're a hero... and you have to leave.''</i>"
      if character.has_badge?("Found the Water Chip!") == false
        if character.kills_by_rat_type("Overseer") >= 1
          character.award_badge("Found the Water Chip!")
        end
      end
      
      # "You need to call Tyrone!"
      if character.has_badge?("You need to call Tyrone!") == false
        if character.total_bounty >= 100000000
          character.award_badge("You need to call Tyrone!")
        end
      end
      
      # "Triple your ISK... honestly"
      if character.has_badge?("Triple your ISK... honestly") == false
        if character.total_bounty >= 300000000
          character.award_badge("Triple your ISK... honestly")
        end
      end
      
      # "Love the smell of Plex!"
      if character.has_badge?("Love the smell of Plex!") == false
        if character.total_bounty >= 600000000
          character.award_badge("Love the smell of Plex!")
        end
      end

      # "Great Scott!"
      if character.has_badge?("Great Scott!") == false
        if character.total_bounty >= 1200000000
          character.award_badge("Great Scott!")
        end
      end
      
      # "Greed is good!"
      if character.has_badge?("Greed is good!") == false
        if character.total_bounty >= 2000000000
          character.award_badge("Greed is good!")
        end
      end
      
      # "Eastbound and down..."
      if character.has_badge?("Eastbound and down...") == false
        if character.kills_by_rat_type("Hauler") >= 1
          character.award_badge("Eastbound and down...")
        end
      end
      
      Log.info "FINISHED Badge awarding for: #{character[:name]}"

    end
    finish = Time.now.to_i
    duration = finish - start
    Log.info "COMPLETED Badge awarding for all, took: #{duration} seconds"
  end
end
 
module Clockwork
  every 60.minutes, 'award_badges' do
    AwardBadges.perform
  end
end
