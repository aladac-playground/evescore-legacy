class TrustController < ApplicationController
  before_filter :check_trust
  def grant
  end
  
  private
  def check_trust
    if request.headers['HTTP_EVE_TRUSTED'] == "Yes" and request.user_agent =~ /EVE-IGB$/
      redirect_to session[:return_to]
    end
  end
  
end
