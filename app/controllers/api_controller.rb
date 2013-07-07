class ApiController < ApplicationController
  require 'net/http'
  def import
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
