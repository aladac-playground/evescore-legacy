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
      if character.kills >= 1000
        character.award_badge("Bring me 1000 rat tails!")
      end
      
      # "On with the race"
      if character.kills >= 2000
        character.award_badge("On with the race")
      end
      
      # "You Guristas scum..."
      # "You are fighting the good fight and in that fight you sunk 1000 Guristas ships"
      if character.kills_by_rat_type("Guristas") >= 1000
        character.award_badge("You Guristas scum...")
      end
      
      # "Scaring the nation..."
      if character.kills_by_rat_type("Sansha's") >= 1000
        character.award_badge("Scaring the nation...")
      end     
      
      # "With blood and rage of crimson red..."
      if character.kills_by_rat_type("Blood") >= 1000
        character.award_badge("With blood and rage of crimson red...")
      end           
      
      # "Found the Water Chip!"
      # "Awarded for killing a Deadspace Overseer.<br><i>''You're a hero... and you have to leave.''</i>"
      if character.kills_by_rat_type("Overseer") >= 1
        character.award_badge("Found the Water Chip!")
      end
      
      # "You need to call Tyrone!"
      if character.total_bounty >= 100000000
        character.award_badge("You need to call Tyrone!")
      end
      
      # "Triple your ISK... honestly"
      if character.total_bounty >= 300000000
        character.award_badge("Triple your ISK... honestly")
      end
      
      # "Love the smell of Plex!"
      if character.total_bounty >= 600000000
        character.award_badge("Love the smell of Plex!")
      end

      # "Great Scott!"
      if character.total_bounty >= 1200000000
        character.award_badge("Great Scott!")
      end
      
      # "Greed is good!"
      if character.total_bounty >= 2000000000
        character.award_badge("Greed is good!")
      end
      
      # "Eastbound and down..."
      if character.kills_by_rat_type("Hauler") >= 1
        character.award_badge("Eastbound and down...")
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
