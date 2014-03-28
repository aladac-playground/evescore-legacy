class TopController < ApplicationController
  def income
    @income = WalletRecord.non_anon.top_income.page(params[:page]).per(10)
    render :income
  end

  def bounty
    @income = WalletRecord.top_bounty.page(params[:page]).per(10)
    render :income
  end

  def incursion
    @income = WalletRecord.top_incursion.page(params[:page]).per(10)
    render :income
  end

  def corp
    @corps = WalletRecord.corp.page(params[:page]).per(10)
  end

  def alliance
    @alliances = WalletRecord.allied.alliance.page(params[:page]).per(10)
  end
  
  def mission_all
    @income = WalletRecord.non_anon.top_income.mission_all.page(params[:page]).per(10)
    render :income
  end

  def mission_time
    @income = WalletRecord.non_anon.top_income.mission_time.page(params[:page]).per(10)
    render :income
  end
  
  def mission
    @income = WalletRecord.non_anon.top_income.mission.page(params[:page]).per(10)
    render :income
  end
  
  def kills
    @income = Kill.overseer.top_kills.page(params[:page]).per(10)
  end
  
  def ticks
    @income = WalletRecord.non_anon.top_ticks.page(params[:page]).per(10)
    render :income
  end
  
  def rats
    @income = Kill.overseer.top_rats.page(params[:page]).per(10)
  end
end
