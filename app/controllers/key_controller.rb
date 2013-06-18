class KeyController < ApplicationController
  def add
  end
  def save
    Character.create!(char_id: params[:char_id], name: params[:name], key: params[:key], vcode: params[:vcode])
    flash[:notice] = "Ok"
  end
end
