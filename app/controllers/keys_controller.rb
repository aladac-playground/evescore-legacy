class KeysController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_users_keys, only: [ :index ]
  before_action :set_key, only: [:show, :edit, :update, :destroy]
  
  def index
    @keys = Key.where(user_id: current_user.id).all
  end
  
  def show
  end
  
  def new
    @key = Key.new
  end
  
  def create
    @key = Key.new(key_params)

    respond_to do |format|
      @key.user_id = current_user.id
      if @key.save
        @key.import_chars(current_user.id)
        format.html { redirect_to keys_path, notice: 'Key was successfully created.' }
        format.json { render action: 'show', status: :created, location: @key }
      else
        format.html { render action: 'new' }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @key.destroy
    respond_to do |format|
      format.html { redirect_to keys_url }
      format.json { head :no_content }
    end
  end


  
  private
  def check_users_keys
    if user_signed_in?
      if current_user.keys.count == 0
        flash[:warning] = "User doesn't have any keys"
        redirect_to new_key_path
      end
    end
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_key
    @key = Key.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def key_params
    params.require(:key).permit(:vcode, :id, :user_id)
  end
  
end
