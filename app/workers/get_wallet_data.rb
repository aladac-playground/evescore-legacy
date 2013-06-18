class GetWalletData
  include Sidekiq::Worker

  def perform( name, count )
    puts "Hello!"
  end
end
