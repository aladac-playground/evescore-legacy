class ScansController < ApplicationController
  before_action :set_scan, only: [:show, :edit, :update, :destroy]
  before_filter :parse_paste, only: [:update, :create ]
  before_filter :check_trust, except: [ :show ]
  before_filter :check_read_access, only: [:show ]
  before_filter :check_write_access, only: [:edit, :update, :destroy]
  before_filter :current_system, only: [:show]
  before_filter :store_params, only: [:show]

  # GET /scans
  # GET /scans.json
  def index
    @scans = Scan.where(char_id: igb_headers[:char_id] )
  end

  # GET /scans/1
  # GET /scans/1.json
  def show
		if params[:current_only] == "true"
			params[:q][:system_id_eq] = request.headers["HTTP_EVE_SOLARSYSTEMID"]
		end
    
    dt = Time.parse("11:00 UTC")
    last_dt = Time.parse("11:00 UTC") - 1.day
    
		if params[:past] == "true"
			dt = dt - 1.day
			last_dt = last_dt - 1.day
		end

    if Time.now.utc > dt 
      @sigs = @scan.sigs.where "sigs.created_at > '#{dt}'"
    else
      @sigs = @scan.sigs.where "sigs.created_at > '#{last_dt}'"
    end
        
    @search = @sigs.page(params[:page]).per(10).search(params[:q])
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
        format.html { redirect_to @scan, notice: 'Scan was successfully created.' }
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
        format.html { redirect_to scan_path + query_string(session[:p]) }
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
      end
      redirect_to new_scan_path if @scan.nil?
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def scan_params
      params[:scan].permit(:security, :system_id, :char_id, :corp_id, :alliance_id, :paste)
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
          solar_system = SolarSystem.find(params[:system_id])
          sig={ sid: sid, sig_type_id: sig_type.id, sig_group_id: sig_group.id, system_id: solar_system.id, region_id: solar_system.region_id, cons_id: solar_system.cons_id }
          @sigs.push sig
        end
      end
      if @sigs.length == 0 
        flash[:error] = "Paste unparsable"
        redirect_to new_scan_path
      end
    end
    def igb_headers
      { char_id: request.headers["HTTP_EVE_CHARID"], corp_id: request.headers["HTTP_EVE_CORPID"], alliance_id: request.headers["HTTP_EVE_ALLIANCEID"] }
    end
    def check_trust
      if request.headers['HTTP_EVE_TRUSTED'] == "Yes" and request.user_agent =~ /EVE-IGB$/
        return true
      elsif request.user_agent =~ /EVE-IGB$/
        session[:return_to] = request.url
        redirect_to trust_grant_path
      else
        flash[:warn] = "This portion of the site requires IGB access with trust enabled"
        redirect_to root_path
      end
    end
    # TODO refactor check_write and check_read into something less sucky
    def check_write_access
      case @scan.security
        # %option{ value: 1, selected: @scan.security == 1 } Private - Accesible only to the owner
        # %option{ value: 2, selected: @scan.security == 2 } Public - Accesible to anyone with permalink
        # %option{ value: 3, selected: @scan.security == 3 } Secure - Read-only access to anyone with permalink
        # %option{ value: 4, selected: @scan.security == 4 } Corp Only - Accesible to everyone in your Corp
        # %option{ value: 5, selected: @scan.security == 5 } Alliance Only - Accessible to everyone in your Alliance
        # 
      when 1
        auth = true if igb_headers[:char_id].to_i == @scan.char_id
      when 2
        auth = true
      when 3
        auth = true if igb_headers[:char_id].to_i == @scan.char_id
      when 4
        auth = true if igb_headers[:corp_id].to_i == @scan.corp_id
      when 5 
        auth = true if igb_headers[:alliance_id].to_i == @scan.alliance_id
      else
        auth = false
      end
      if auth != true
        flash[:error] = "Permission Denied"
        redirect_to new_scan_path
      end
    end
    def check_read_access
      case @scan.security
        # %option{ value: 1, selected: @scan.security == 1 } Private - Accesible only to the owner
        # %option{ value: 2, selected: @scan.security == 2 } Public - Accesible to anyone with permalink
        # %option{ value: 3, selected: @scan.security == 3 } Secure - Read-only access to anyone with permalink
        # %option{ value: 4, selected: @scan.security == 4 } Corp Only - Accesible to everyone in your Corp
        # %option{ value: 5, selected: @scan.security == 5 } Alliance Only - Accessible to everyone in your Alliance
        # 
      when 1
        auth = true if igb_headers[:char_id].to_i == @scan.char_id
      when 2
        auth = true
      when 3
        auth = true
      when 4
        auth = true if igb_headers[:corp_id].to_i == @scan.corp_id
      when 5 
        auth = true if igb_headers[:alliance_id].to_i == @scan.alliance_id
      else
        auth = false
      end
      if auth != true
        flash[:error] = "Permission Denied"
        redirect_to new_scan_path
      end
    end
    def current_system
      if params[:q] and request.headers["HTTP_EVE_TRUSTED"] == "Yes"
        if params[:q][:system_id_eq] == "current"
          @current = true
          params[:q][:system_id_eq] = request.headers["HTTP_EVE_SOLARSYSTEMID"]
        else
          @current = false
        end
      end
    end
    def session_storables
      [ :past, :current_only, :q ]
    end
    def store_params
      session[:p] = {}
      session_storables.each do |param|
        session[:p][param] = params[param] if params[param].blank? == false
      end
    end
    def query_string(query)
      ! query.to_query.blank? ? "?" + query.to_query : ""
    end
end
