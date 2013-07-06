class LinkController < ApplicationController
  def index
    if session[:igb] != true
      flash[:error] = "EVE IGB required to use this part of site"
      redirect_to root_path
    end
  end

  def new
  end

  def show
  end

  def pap
  end
end
