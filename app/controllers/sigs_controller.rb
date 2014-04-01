class SigsController < ApplicationController
  before_action :set_sig, only: [:show, :edit, :update, :destroy]
  before_filter :check_owner

  # GET /sigs
  def index
    @sigs = Sig.all
  end

  # GET /sigs/1
  def show
  end

  # GET /sigs/new
  def new
    @sig = Sig.new
  end

  # GET /sigs/1/edit
  def edit
  end

  # POST /sigs
  def create
    @sig = Sig.new(sig_params)

    if @sig.save
      redirect_to @sig, notice: 'Sig was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /sigs/1
  def update
    if @sig.update(sig_params)
      redirect_to @sig, notice: 'Sig was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /sigs/1
  def destroy
    @sig.destroy
    # redirect_to sigs_url, notice: 'Sig was successfully destroyed.'
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sig
      @sig = Sig.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def sig_params
      params[:sig]
    end
    def check_owner
      if request.headers["HTTP_EVE_CHARID"].to_i == @sig.scan.char_id or ( user_signed_in? and  current_users.chars.ids.include? @sig.scan.char_id )
        true
      else
        flash[:error] = "Permission Denied"
        redirect_to :back
      end
    end
end
