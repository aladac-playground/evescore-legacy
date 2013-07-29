class RatsController < ApplicationController
  before_filter :name_to_id, :validate_rat_id, :only => :show

  def show
    @rat = Rat.where(rat_id: @rat_id).first
    if ! @rat
      redirect_to root_path
    end
  end
  private
  def name_to_id
    if params[:rat_name] 
      rat = Rat.where(:rat_name => params[:rat_name]).first
      if rat
        @rat_id = rat.rat_id
      else
        redirect_to root_path
      end
    end
  end
  def validate_rat_id
    @rat_id = params[:rat_id] if params[:rat_id]
    if ! @rat_id or @rat_id.numeric? == false
      redirect_to root_path
    elsif Rat.where(:rat_id => @rat_id).first == nil
      redirect_to root_path
    end
  end

end
