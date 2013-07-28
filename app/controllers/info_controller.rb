class InfoController < ApplicationController
  def badges
  end
  def about
  end

  def faq
  end

  def changelog
    @news = News.order_by(:created_at.desc)
  end
  
  def contact
    if request.headers["HTTP_USER_AGENT"] !~ /EVE-IGB$/ and ! session[:igb_contact_nag] 
      flash.now[:info] = "If you visit this page from IGB, direct EVE mail contact will appear"
      session[:igb_contact_nag] = true
    end
  end
end
