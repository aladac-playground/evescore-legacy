class KillsController < ApplicationController
  def log
    @kill_log = Kill.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 12)
  end
end
