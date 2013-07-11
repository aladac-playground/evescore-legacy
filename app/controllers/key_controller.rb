class KeyController < ApplicationController
  def add
    if session[:key_help].nil?
      flash.now[:info] = %Q|<p>In order to add your API key you need to generate a key with access to the Wallet Journal for a
      <b>SINGLE</b>
      character only.
      To generate a predefined key click the button below (it will open a new page/tab), and on the API page choose a character from the Character select field.
      </p>
      <p>
      <a href='https://support.eveonline.com/api/key/CreatePredefined/2097152' target='_blank'>
      <button class='btn btn-info'>Generate Key</button>
      </a></p>|.html_safe
      session[:key_help] = true
    end
  end
  def save
    api = Eve::Api.new(params[:key], params[:vcode])
    key_info = api.api_key_info
    key = Key.new(key_info)
    char = api.characters.first
    if key.valid?
      key.save
      corp = Corp.create!(corp_id: char[:corp_id], name: char[:corp_name])
      key.characters.create!(char)
      flash[:info] = "Character key successfuly stored"
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
