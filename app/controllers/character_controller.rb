class CharacterController < ApplicationController
  before_filter :name_to_id, :validate_char_id, :only => :profile
  
  def profile
    @character = Character.where(:char_id => @char_id).first
    @kill_log = Bounty.where(char_id: @char_id)
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 5)
    @daily = Bounty.daily(@char_id.to_i, 30)
  end
  
  private
  def name_to_id
    if params[:char_name] 
      @char_id = Character.where(:name => params[:char_name]).first.char_id
    end
  end
  def validate_char_id
    @char_id = params[:char_id] if params[:char_id]
    if ! @char_id or @char_id.numeric? == false
      redirect_to root_path
    elsif Character.where(:char_id => @char_id).first == nil
      redirect_to root_path
    end
  end
end
