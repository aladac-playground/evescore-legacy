class CharacterController < ApplicationController
  def profile
    @daily = Bounty.daily(params[:char_id].to_i, 30)
  end
end
