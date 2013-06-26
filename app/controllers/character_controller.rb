class CharacterController < ApplicationController
  before_filter :validate_char_id
  
  def profile
    @character = Character.where(:char_id => params[:char_id]).first
    @kill_log = Bounty.where(char_id: params[:char_id])
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 5)
    @daily = Bounty.daily(params[:char_id].to_i, 30)
  end
  
  private
  def validate_char_id
    if ! params[:char_id] or params[:char_id].numeric? == false 
      redirect_to root_path
    elsif Character.where(:char_id => params[:char_id]).first == nil
      redirect_to root_path
    end
  end
end
