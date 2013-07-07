class KeyController < ApplicationController
  def add
  end
  def save
    char = Character.new(char_id: params[:char_id], name: params[:name], key: params[:key], vcode: params[:vcode])
    key = Key.new(key_id: params[:key], vcode: params[:vcode])
    if key.valid?
      key.save
      flash[:notice] = "Character key successfuly stored"
      redirect_to api_import_path(:char_id => params[:char_id])
    else
      error_alert = String.new
      char.errors.messages.each_pair do |field, message|
        error_alert += message[0]
      end
      flash[:error] = error_alert
      redirect_to key_add_path
    end
  end
end
