class CharacterController < ApplicationController
  def profile
    if ! params[:char_id]
      redirect_to root_path
    else
      @char_id = params[:char_id]
    end
    @kill_log = Bounty.where(char_id: @char_id)
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 5)
    @daily = Bounty.daily(params[:char_id].to_i, 30)
  end
end
