class CharacterController < ApplicationController
  def profile
    @daily = Bounty.daily(params[:char_id].to_i)
  end
end
