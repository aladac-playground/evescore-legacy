class ScansController < ApplicationController
  before_action :set_scan, only: [:show, :edit, :update, :destroy]
  before_filter :parse_paste, only: [:update, :create ]

  # GET /scans
  # GET /scans.json
  def index
    @scans = Scan.all
  end

  # GET /scans/1
  # GET /scans/1.json
  def show
    @search = @scan.sigs.page(params[:page]).per(10).search(params[:q])
    @sigs = @search.result
  end

  # GET /scans/new
  def new
    @scan = Scan.new
  end

  # GET /scans/1/edit
  def edit
  end

  # POST /scans
  # POST /scans.json
  def create
    @scan = Scan.new(scan_params)
    
    respond_to do |format|
      if @scan.save
        if @sigs
          @sigs.each do |sig|
            @scan.sigs.create(sig)
          end
        end
        format.html { redirect_to "/scan/#{@scan.secure_id}", notice: 'Scan was successfully created.' }
        format.json { render action: 'show', status: :created, location: @scan }
      else
        format.html { render action: 'new' }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scans/1
  # PATCH/PUT /scans/1.json
  def update
    respond_to do |format|
      if @scan.update(scan_params)
        if @sigs
          @sigs.each do |sig|
            @scan.sigs.create(sig)
          end
        end
        format.html { redirect_to "/scan/#{@scan.secure_id}", notice: 'Scan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @scan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scans/1
  # DELETE /scans/1.json
  def destroy
    @scan.destroy
    respond_to do |format|
      format.html { redirect_to scans_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scan
      if params[:id]
        @scan = Scan.find(params[:id])
      else
        @scan = Scan.where(secure_id: params[:secure_id]).first
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scan_params
      params[:scan]
    end
    def parse_paste
      if params[:paste]
        paste = params[:paste].split("\n")
      else
        flash[:error] = "Paste empty"
        redirect_to new_scan_path
      end
      @sigs = []
      paste.each do |line|
        # IMY-400	Cosmic Signature	Data Site	Central Guristas Sparking Transmitter	100,00%	31,51 AU
        if line =~ /^(\w{3}-\d{3})\t.*\t(.*)\t(.*)\t(.*)\t(.*)$/
          sid = $1
          sig_group = SigGroup.where(name: $2).first
          next if sig_group.nil?
          sig_type = "-" if ( sig_type.nil? or sig_type.blank? )
          sig_type = SigType.where(name: $3).first
          if sig_type.nil?
            sig_type = SigType.create(name: $3)
          end
          # Sig(id: integer, scan_id: integer, char_id: integer, corp_id: integer, system_id: integer, cons_id: integer, region_id: integer, alliance_id: integer, sig_type_id: integer, sig_group_id: integer, created_at: datetime, updated_at: datetime)
          sig={ sid: sid, sig_type_id: sig_type.id, sig_group_id: sig_group.id }
          @sigs.push sig
        end
      end
      if @sigs.length == 0 
        flash[:error] = "Paste unparsable"
        redirect_to new_scan_path
      end
    end
end
