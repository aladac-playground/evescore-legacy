class LinkController < ApplicationController
  before_filter :check_igb
  def index
    @links = Link.where(char_id: @char[:id])
  end
  
  def update
    @link.find(id: Moped::BSON::ObjectId(params[:link][:id]))      
  end

  def new
    if @char and Link.links(@char[:id]) < 2
      @link = Link.create!(ts: Time.now.utc, char_id: @char[:id], char_name: @char[:name] )
    elsif Link.links(@char[:id]) >= 2
      flash[:error] = "You have over 2 links aleady, delete some before adding more"
    else
      flash[:error] = "You need to be using this from IGB with trust enabled"
    end
    redirect_to :action => :index
  end
  
  def delete
    Link.find(Moped::BSON::ObjectId(params[:link_id])).delete
    redirect_to :action => :index
  end

  def show
  end

  def pap
  end
  
  private
  def check_igb
    if session[:igb] != true
      flash[:error] = "EVE IGB required to use this part of site"
      redirect_to root_path
    end
  end
end
