namespace :import do
  desc "Import character and key data from the legacy app"
  task :chars => :environment do
    session = Moped::Session.new([ "127.0.0.1:27017", "127.0.0.1:27018", "127.0.0.1:27019" ])
    session.use :evescore_development
    
    chars = session[:characters]
    keys = session[:keys]
    
    records = chars.find.count
    
    pb = ProgressBar.create(:title => "Migrating Chars", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 )
    
    chars.find.each do |char|
      key_id = char["key_id"]
      key = keys.find("_id" => key_id).first 
      api = Eve::Api.new(key["key_id"], key["vcode"])
      info = api.api_key_info
      if info 
        if ( 2097152 & info[:access_mask].to_i ) != 0
          #  => Key(id: integer, vcode: string, mask: integer, working: boolean, created_at: datetime, updated_at: datetime, user_id: integer, key_type: string, expires: datetime)
          k = Key.create!(id: info[:key_id], vcode: info[:vcode], mask: info[:access_mask], working: true, 
            key_type: info[:type], expires: info[:expires]
          )
        else
          next
        end
      else
        next
      end
      if char["bear"]
        anon = true
      else
        anon = false
      end
      c = api.characters
      if c
        c.each do |api_char|
          char_name = api_char[:name]
          char_id = api_char[:char_id].to_i
          corp_id = api_char[:corp_id].to_i
          corp_name = api_char[:corp_name]
          corp = Corp.where(id: corp_id).first
          if ! corp
            allied = Allied.where(corp_id: corp_id).first
            if allied
              alliance_id = allied.alliance_id
              alliance_name = Alliance.find(alliance_id).name
            else
              alliance_id = nil
              alliance_name = nil
            end
            corp = Corp.create(name: corp_name , id: corp_id, alliance_id: alliance_id, alliance_name: alliance_name)
          else
            if corp.alliance
              alliance_id = corp.alliance.id
              alliance_name = corp.alliance.name
            else
              alliance_id = nil
              alliance_name = nil
            end
          end
          Char.create(id: char_id, name: char_name, corp_id: corp_id, key_id: info[:key_id], corp_name: corp_name, 
            alliance_name: alliance_name, alliance_id: alliance_id, anon: anon)
        end
      end
      pb.increment
    end
  end
  desc "Import characters w/o valid key data"
  task :naked => :environment do
    session = Moped::Session.new([ "127.0.0.1:27017", "127.0.0.1:27018", "127.0.0.1:27019" ])
    session.use :evescore_development
  
    chars = session[:characters]
    keys = session[:keys]
  
    records = chars.find.count
  
    pb = ProgressBar.create(:title => "Migrating Chars", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 )
  
    chars.find.each do |char|
      if char["corp_id"] == 0
        pb.increment
        next
      end
      Char.import(char)
      pb.increment
    end
    
  end
end