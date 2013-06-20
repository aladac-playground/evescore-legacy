class KillsController < ApplicationController
  def log
    @kill_log = Kill.all
    if params[:filter]
      params[:filter].each_pair do |fil, val|
        fil = fil.to_s
        p fil
        if Kill.attribute_names.include?(fil)
          @kill_log = @kill_log.where(fil.to_sym => val)
        end
      end
    end
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 12)
  end
end
