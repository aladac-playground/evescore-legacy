class CharacterController < ApplicationController
  before_filter :validate_char_id, :only => :profile
  
  def profile
    @character = Character.where(:char_id => params[:char_id]).first
    @kill_log = Bounty.where(char_id: params[:char_id])
    @kill_log = @kill_log.order_by(ts: 'desc').paginate(:page => params[:page], :per_page => 5)
    @daily = Bounty.daily(params[:char_id].to_i, 30)
  end

  def all
    @characters = Array.new
    Character.all.each do |char|
      character = { name: char.name, id: char.char_id, value: char.name }
      @characters.push character
    end
    respond_to do |format|
      format.json  { render :json => @characters.to_json }
    end
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
