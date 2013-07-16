class RatsController < ApplicationController
  def show
    @rat = Rat.where(rat_id: params[:rat_id]).first
    if ! @rat
      redirect_to root_path
    end
  end
end
