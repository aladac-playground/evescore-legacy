class RatsController < ApplicationController
  before_action :set_rat, only: [:show, :edit, :update, :destroy, :group]
  before_filter :faction_acl, only: :groups

  # GET /rats
  # GET /rats.json
  def factions
    
  end

  def groups
    if params[:faction]
      @faction = params[:faction].gsub(/_/," ")
      faction=@faction.gsub(/\'/,"''")
      @groups = Rat.select("distinct(rat_type) as name").where("rat_type like '%#{faction}%'").order("rat_type").page(params[:page]).per(10)
    end
  end
  
  def index
    if params[:rat_type]
      @rat_type = params[:rat_type].gsub(/_/," ")
      @rats = Rat.where(rat_type: @rat_type).page(params[:page]).per(20)
    else
      @rats = Rat.group(:rat_type).page(params[:page]).per(20)
    end
  end
  
  def rat_type
    p params
    if params[:rat_type]
      @rat_type = params[:rat_type].gsub(/_/," ")
      @rats = Rat.where(rat_type: @rat_type).page(params[:page]).per(20)
    else
      redirect_to root_path
    end
  end
  
  # GET /rats/1
  # GET /rats/1.json
  def show
    @gun_dps = @rat.gun_dps
    @missile_dps = @rat.missile_dps
  end

  # GET /rats/new
  # def new
  #   @rat = Rat.new
  # end
  # 
  # # GET /rats/1/edit
  # def edit
  # end
  # 
  # # POST /rats
  # # POST /rats.json
  # def create
  #   @rat = Rat.new(rat_params)
  # 
  #   respond_to do |format|
  #     if @rat.save
  #       format.html { redirect_to @rat, notice: 'Rat was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @rat }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @rat.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PATCH/PUT /rats/1
  # # PATCH/PUT /rats/1.json
  # def update
  #   respond_to do |format|
  #     if @rat.update(rat_params)
  #       format.html { redirect_to @rat, notice: 'Rat was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @rat.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /rats/1
  # # DELETE /rats/1.json
  # def destroy
  #   @rat.destroy
  #   respond_to do |format|
  #     format.html { redirect_to rats_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rat
      @rat = Rat.where(id: params[:id]).first
      if ! @rat
        redirect_to root_path
      end
      @desc = @rat.description
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rat_params
      params[:rat]
    end
    
    def faction_acl
      acl = [ 
        "Guristas",
        "Serpentis",
        "Caldari",
        "Gallente",
        "Amarr",
        "Minmatar",
        "Blood_Raiders",
        "Angel_Cartel",
        "Sansha's_Nation",
        "Concord"
      ]
      if acl.include? params[:faction]
        return true
      else
        redirect_to root_path
      end
    end

    
end
