class ApiController < ApplicationController
  def import
    char = Character.where(char_id: params[:char_id]).first
    key = char.key
    api = Eve::Api.new(key[:key_id], key[:vcode])    
    wallet = api.wallet_journal
    wallet.wallet_import
    redirect_to character_profile_path(:char_id => params[:char_id])
  end
  def verify
    api = Eve::Api.new(params[:key], params[:vcode])
    characters = api.characters
    if characters
      character = characters.first
      valid = true
    else
      valid = false
    end
    @verify = { valid: valid, character: character }
    respond_to do |format|
      format.json { render json: @verify }
    end
  end
end
