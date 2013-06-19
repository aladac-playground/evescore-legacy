class KillsController < ApplicationController
  def log
    @kill_log = Kill.paginate(:page => params[:page], :per_page => 30)
  end
end
