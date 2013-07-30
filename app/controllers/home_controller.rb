class HomeController < ApplicationController
  def index
    # if @trust == true and  ! session[:char_profile_nag]
    #   flash.now[:info] = "Hello #{@char[:name]}, you can visit your profile #{ActionController::Base.helpers.link_to "here", character_profile_path(:char_id => @char[:id])}".html_safe
    #   session[:char_profile_nag] = true
    # end
  end
  def corps
    
  end
  def players
  end
end
