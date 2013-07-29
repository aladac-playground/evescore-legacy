class CorpController < ApplicationController
  before_filter :name_to_id, :validate_corp_id, :only => :profile
  
  def profile
    @corp = Corp.where(:corp_id => @corp_id).first
    @daily = Bounty.tax_daily(@corp.corp_id)
    @total_tax = Bounty.total_tax(@corp_id)
    @tax_contrib = Bounty.tax_contrib(@corp_id.to_i)
    @tax_this_month = Bounty.tax_this_month(@corp_id.to_i)
  end
  
  private
  def name_to_id
    if params[:corp_name] 
      corp = Corp.where(:name => params[:corp_name]).first
      if corp
        @corp_id = corp.corp_id
      else
        redirect_to root_path
      end
    end
  end
  def validate_corp_id
    @corp_id = params[:corp_id] if params[:corp_id]
    if ! @corp_id or @corp_id.numeric? == false
      redirect_to root_path
    elsif Corp.where(:corp_id => @corp_id).first == nil
      redirect_to root_path
    end
  end
end
