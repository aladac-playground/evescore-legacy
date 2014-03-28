class CharsController < ApplicationController
  before_action :set_char, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [ :show ]
  before_filter :check_users_chars, only: [ :index ]
  before_filter :check_anon, only: [ :show ]

  # GET /chars
  # GET /chars.json
  def index
    @chars = Char.where("user_id = #{current_user.id} and ( anon = 1 or anon <> 1 or anon is null )")
  end

  # GET /chars/1
  # GET /chars/1.json
  def show
    @wallet = @char.wallet_records.order("ts desc").page(params[:page]).per(5)
  end

  # GET /chars/new
  def new
    @char = Char.new
  end

  # GET /chars/1/edit
  def edit
  end

  # POST /chars
  # POST /chars.json
  def create
    @char = Char.new(char_params) 

    respond_to do |format|
      if @char.save
        format.html { redirect_to @char, notice: 'Char was successfully created.' }
        format.json { render action: 'show', status: :created, location: @char }
      else
        format.html { render action: 'new' }
        format.json { render json: @char.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chars/1
  # PATCH/PUT /chars/1.json
  def update
    respond_to do |format|
      if @char.update(char_params)
        format.html { redirect_to chars_url, notice: 'Char was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @char.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chars/1
  # DELETE /chars/1.json
  def destroy
    @char.destroy
    respond_to do |format|
      format.html { redirect_to chars_url }
      format.json { head :no_content }
    end
  end

  private
  
    def check_anon
      if @char.anon == true
        redirect_to root_path unless ( user_signed_in? and @char.user_id == current_user.id )
      end
    end
  
    def check_users_chars
      if user_signed_in?
        if current_user.chars.where("user_id = #{current_user.id} and ( anon = 1 or anon <> 1 or anon is null )").count == 0
          flash[:warning] = "User doesn't have any characters. Add an API Key"
          redirect_to new_key_path
        end
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_char
      @char = Char.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def char_params
      params[:char].permit(:anon)
    end
end
