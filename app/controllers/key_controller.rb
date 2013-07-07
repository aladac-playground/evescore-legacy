class KeyController < ApplicationController
  def add
  end
  def save
    api = Eve::Api.new(params[:key], params[:vcode])
    key_info = api.api_key_info
    key = Key.new(key_info)
    char = api.characters.first
    p char
    p key
    if key.valid?
      key.save
      key.characters.create!(char)
      flash[:notice] = "Character key successfuly stored"
      redirect_to api_import_path(:char_id => params[:char_id])
    else
      error_alert = String.new
      key.errors.messages.each_pair do |field, message|
        error_alert += message[0]
      end
      flash[:error] = error_alert
      redirect_to key_add_path
    end
  end
end
