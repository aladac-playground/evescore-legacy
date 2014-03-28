class WalletController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_users_wallet, only: [ :index ]
  
  def index
    @wallet = WalletRecord.where(char_id: current_user_chars).page(params[:page]).per(10)
  end
  
  private
  def check_users_wallet
    if user_signed_in?
      if WalletRecord.where(char_id: current_user_chars).count == 0
        flash[:warning] = "User doesn't have any Wallet Records"
        redirect_to root_path
      end
    end
  end
  
  def current_user_chars
    char_ids = []
    current_user.chars.each do |char|
      char_ids.push char.id
    end
    char_ids
  end
end
