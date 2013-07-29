class ApiController < ApplicationController
  def search
    if params[:text] 
      @search = Array.new
      Corp.any_of(name: /#{params[:text]}/i).to_a.each do |corp|
        c = { 
          name: corp.name,
          value: corp.name,
          path: "/corp/profile",
          field_name: "corp_name",
          field_value: corp.name,
          type: "Corporation",
          image: "#{corp.corp_id}_32.png"
        }
        @search.push c
      end
      Character.any_of(name: /#{params[:text]}/i).to_a.each do |char|
        c = { 
          name: char.name,
          value: char.name,
          path: "/character/profile",
          field_name: "char_name",
          field_value: char.name,
          type: "Character",
          image: "#{char.char_id}_32.png"
        }
        @search.push c
      end
      Rat.any_of(rat_name: /#{params[:text]}/i).to_a.each do |rat|
        c = { 
          name: rat.rat_name,
          value: rat.rat_name,
          path: "/rats/show",
          field_name: "rat_name",
          field_value: rat.rat_name,
          type: "Rat",
          image: "Type/#{rat.rat_id}_32.png"
        }
        @search.push c
      end
    else
      @search = nil
    end
    respond_to do |format|
      format.json { render json: @search }
    end
  end
  

  def import
    char = Character.where(char_id: params[:char_id]).first
    key = char.key
    api = Eve::Api.new(key[:key_id], key[:vcode])
    api.char_id = params[:char_id]
    api.rows = 3000
    wallet = api.wallet_journal
    wallet.wallet_import
    redirect_to character_profile_path(:char_name => char.name)
  end
  def verify
    if Key.where(key_id: params[:key]).count > 0
      valid = false
      message = "Key already exists in database!"
    else
      api = Eve::Api.new(params[:key], params[:vcode])
      characters = api.characters
      num = characters.size
      if characters and num == 1
        character = characters.first
        if Character.where(char_id: character[:char_id]).empty?
          valid = true 
        else
          valid = false
          message = "Character already exists in database!"
        end
      elsif num != 1
        valid = false
        message = "Please generate a key for a single character! Account keys not yet supported."
      else
        valid = false
      end
      mask = api.api_key_info[:access_mask].to_i
      check = 2097152 & mask
      if check == 0
        valid = false
        message = "No wallet journal permissions!"
      end
    end
    @verify = { valid: valid, character: character, message: message ? message : nil }
    respond_to do |format|
      format.json { render json: @verify }
    end
  end
end
