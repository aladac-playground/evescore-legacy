# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file .env file.
# puts 'DEFAULT USERS'
# user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# puts 'user: ' << user.name
# user.confirm!

api = Eve::Api.new(1,1)
puts "Importing Alliance to Corp mappings, this could take a while..."
api.alliance_list

puts 
puts "Importing Static Data"

rats = File.readlines("db/rats.tsv")

records=rats.count

pb = ProgressBar.create(:title => "Seeding Rats", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 ) 
rats.each do |line|
  line.chomp!
  line = line.split("\t")
  tmp = {
    id: line[0],
    name: line[1],
    rat_type: line[2],
    description: line[3]
  }
  Rat.create(tmp)
  pb.increment
end

rat_images = YAML.load_file("db/rat_images.yml")

records=rat_images.count 

pb = ProgressBar.create(:title => "Seeding Rat Images", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 )

rat_images.each do |image|
  r=RatImage.new(image)
  r.save
  pb.increment
end

attribs = File.readlines("db/type_attribs.tsv")

records=attribs.count

pb = ProgressBar.create(:title => "Seeding Type Attribs", :starting_at => 0, :total => records, :format => '%a |%b>>%i| %p%% %t', length: 100 ) 
attribs.each do |line|
  line.chomp!
  line = line.split("\t")
  tmp = {
    type_id: line[0],
    name: line[1].strip,
    value: line[2]
  }
  TypeAttrib.create(tmp)
  pb.increment
end
