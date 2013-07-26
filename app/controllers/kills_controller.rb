class KillsController < ApplicationController
  def log
    @kill_log = Bounty.all
    if params[:filter]
      params[:filter].each_pair do |fil, val|
        fil = fil.to_s
        if Bounty.attribute_names.include?(fil)
          @kill_log = @kill_log.where(fil.to_sym => val)
        end
      end
    end
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 8)
  end
  def ratlog
    if params[:filter]
      @kill_log = Bounty.kills_by_rat_type(params[:filter])
    else
      @kill_log = Bounty.rat_kills      
    end
    @kill_log = @kill_log.paginate(:page => params[:page], :per_page => 8)
  end
  def ladder
    i = 0
    ladder_array = Bounty.top_bounty(0).each do |row|
      i += 1
      row.merge!({ :pos => i })
    end
    p ladder_array
    @ladder = ladder_array.paginate(:page => params[:page], :per_page => 10)
  end
end
