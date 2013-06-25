class CharacterController < ApplicationController
  def profile
    if ! params[:char_id]
      redirect_to root_path
    else
      @char_id = params[:char_id]
    end
    @daily = Bounty.daily(params[:char_id].to_i, 30)
  end
end
