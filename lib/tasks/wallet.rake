namespace :wallet do
  # TODO add character info update (corp_id, alliance_id etc)
  desc 'Import WalletRecords for all Chars from the WalletJournal API' 
  task :import do
    require "#{Rails.root}/config/boot"
    require "#{Rails.root}/config/environment"
    chars=Char.all
    records=chars.count
    
    log = Logger.new(STDOUT)
    
    exit if records == 0

    i = 0
    chars.each do |char|
      i += 1
      log.info "Importing [#{i} if #{records}]"
      char.wallet_import(3000)
    end
  end
end