class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :page_validation, :using_igb?, :current_char

  private 
  def page_validation
    if params[:page].numeric? == false 
      params[:page] = 1
    elsif params[:page].to_i <= 0
      params[:page] = 1
    end
  end
  def using_igb?  
    if request.headers["HTTP_USER_AGENT"] =~ /EVE-IGB$/
      session[:igb] = true
    end
  end
  def current_char
    if using_igb?
      id = request.headers["HTTP_EVE_CHARID"]
      name = request.headers["HTTP_EVE_CHARNAME"]
      char = { id: id, name: name}
      session[:char] = char
    else
      return nil
    end
  end  
end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end
