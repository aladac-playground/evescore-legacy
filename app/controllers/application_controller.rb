class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :page_validation

  private 
  def page_validation
    if params[:page].numeric? == false 
      params[:page] = 1
    elsif params[:page].to_i <= 0
      params[:page] = 1
    end
  end
end
class String
  def numeric?
    Float(self) != nil rescue false
  end
end
