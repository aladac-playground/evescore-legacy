class RatsController < ApplicationController
  def show
    @rat = Rat.where(rat_id: params[:rat_id]).first
  end
end
