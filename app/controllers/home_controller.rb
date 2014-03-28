class HomeController < ApplicationController
  def index
    @users = User.all
    @wallet = WalletRecord.non_anon
    @kills = Kill.non_anon
  end
end
