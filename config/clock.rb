require_relative "../config/boot"
require_relative "../config/environment"
 
class GetWalletData
  def self.perform(rows=3000)
    chars=Char.all
		count=Char.count
		i=0
    chars.each do |char|
			i+=1
			total=sprintf("%3d",count)
			current=sprintf("%3d",i)
			start = Time.now
      char.wallet_import
			finish = Time.now
			ts = finish.strftime("%Y-%m-%d %H:%M:%S")
			duration = sprintf("%.2f",finish-start)
			puts "#{ts} [#{current}/#{total}] Char: #{char.id}\t Took: #{duration}s"
    end
  end
end
 
module Clockwork
  every 20.minutes, 'Getting Wallet Data' do
    GetWalletData.perform
  end
end
