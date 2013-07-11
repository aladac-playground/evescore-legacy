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
    if Key.where(key_id: params[:key]).count > 0
      valid = false
      message = "Key already exists in database!"
    else
      api = Eve::Api.new(params[:key], params[:vcode])
      characters = api.characters
      if characters
        character = characters.first
        if Character.where(char_id: character[:char_id]).empty?
          valid = true 
        else
          valid = false
          message = "Character already exists in database!"
        end
      else
        valid = false
      end
    end
    @verify = { valid: valid, character: character, message: message ? message : nil }
    respond_to do |format|
      format.json { render json: @verify }
    end
  end
end
