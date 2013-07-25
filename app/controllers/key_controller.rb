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
  def delete
    if params[:key] and params[:vcode]
      if params[:key].length != 7 or params[:vcode].length != 64
        flash.now[:warning] = "Check the format"
      else
        key = Key.where(key_id: params[:key], vcode: params[:vcode]).first
        char = key.characters.first
        key.delete
        char.delete
        msg = Array.new
        Bounty.where(char_id: char.char_id).delete ? msg.push("Bounties") : nil
        Incursion.where(char_id: char.char_id).delete ? msg.push("Incrusion rewards") : nil
        CharacterBadge.where(char_id: char.char_id).delete ? msg.push("Badges") : nil
        flash.now[:info] = msg.join(", ") + " deleted"
      end
    else
      flash.now[:error] = %Q|This will delete your key and all the data associated with it!|
    end
  end
  def save
    api = Eve::Api.new(params[:key], params[:vcode])
    key_info = api.api_key_info
    key = Key.new(key_info)
    char = api.characters.first
    if params[:anon] == "anon"
      char[:name] = "New Eden Citizen " + rand(99999).to_s
      char[:corp_id] = 0
      char[:corp_name] = "Generic Corp"
      char[:bear] = (rand(4) + 1)
    end
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
