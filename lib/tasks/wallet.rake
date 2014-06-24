namespace :wallet do
  desc 'Import WalletRecords for all Chars from the WalletJournal API' 
  task :import do
    require "#{Rails.root}/config/boot"
    require "#{Rails.root}/config/environment"
    chars=Char.all
    records=chars.count
    
    exit if records == 0

    pb = ProgressBar.create(:title => "Importing WalletJournals", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 )

    chars.each do |char|
      char.wallet_import(3000)
      pb.increment
    end
  end
end