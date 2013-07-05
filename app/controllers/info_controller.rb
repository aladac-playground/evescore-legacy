class InfoController < ApplicationController
  def about
  end

  def faq
  end

  def changelog
  end
  
  def contact
    if request.headers["HTTP_USER_AGENT"] !~ /EVE-IGB$/ and ! session[:igb_contact_nag] 
      flash.now[:info] = "If you visit this page from IGB, direct EVE mail contact will appear"
      session[:igb_contact_nag] = true
    end
  end
end
