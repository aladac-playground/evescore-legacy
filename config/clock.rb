require_relative "../config/boot"
require_relative "../config/environment"
 
class GetWalletData
  def self.perform
    chars=Char.all
    chars.each do |char|
      char.wallet_import
    end
  end
end
 
module Clockwork
  every 20.minutes, 'Getting Wallet Data' do
    GetWalletData.perform
  end
end
