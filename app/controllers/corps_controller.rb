class CorpsController < ApplicationController
  before_action :set_corp, only: [:show, :edit, :update, :destroy]

  # GET /corps
  # GET /corps.json
  def index
    @corps = Corp.all
  end

  # GET /corps/1
  # GET /corps/1.json
  def show    
    members = @corp.members_income
    
    if params[:q]
      if params[:q][:ts_lteq]
        date_to = params[:q][:ts_lteq]
        if date_to =~ /^\d{4}-\d{2}-\d{2}$/
          params[:q][:ts_lteq]=Time.parse(date_to).strftime("%Y-%m-%d 23:59:59")
        end
      end
      if params[:q][:s]=="amount asc"
        @search=members.sort_by_sum_amount_asc.page(params[:page]).per(10).search
      elsif params[:q][:s]=="amount desc"
        @search=members.sort_by_sum_amount_desc.page(params[:page]).per(10).search        
      else
        @search = members.page(params[:page]).per(10).search(params[:q])        
      end
    end
    
    @search = members.search(params[:q])
    @members_income = @search.result
    
  end

  # GET /corps/new
  def new
    @corp = Corp.new
  end

  # GET /corps/1/edit
  def edit
  end

  # POST /corps
  # POST /corps.json
  def create
    @corp = Corp.new(corp_params)

    respond_to do |format|
      if @corp.save
        format.html { redirect_to @corp, notice: 'Corp was successfully created.' }
        format.json { render action: 'show', status: :created, location: @corp }
      else
        format.html { render action: 'new' }
        format.json { render json: @corp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /corps/1
  # PATCH/PUT /corps/1.json
  def update
    respond_to do |format|
      if @corp.update(corp_params)
        format.html { redirect_to @corp, notice: 'Corp was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @corp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corps/1
  # DELETE /corps/1.json
  def destroy
    @corp.destroy
    respond_to do |format|
      format.html { redirect_to corps_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_corp
      @corp = Corp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def corp_params
      params[:corp]
    end
end
