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

api = Eve::Api.new
puts "Downloading Alliance to Corp mappings, this could take a while..."
allied = api.allied

tmp=Tempfile.new("allied")
tmp.puts allied

puts "Loading Alliance to Corp mapping"

path = tmp.path
query = "LOAD DATA LOCAL INFILE '#{path}' into table allies ( alliance_id, corp_id );"
ActiveRecord::Migration.execute query

puts "Loading Entity Details (Rats)"

file = "rats.tsv.gz"
dir = Dir.pwd
path = dir + "/db/" + file
puts "Decompressing source file"
gzip = File.read(path)
tsv = ActiveSupport::Gzip.decompress(gzip)

tmp = Tempfile.new("rats")
tmp.puts tsv
path = tmp.path

query = "LOAD DATA LOCAL INFILE '#{path}' into table rats ( id, name, rat_type, description );"
ActiveRecord::Migration.execute query

puts "Loading Type Attributes"

file = "type_attribs.tsv.gz"
dir = Dir.pwd
path = dir + "/db/" + file
puts "Decompressing source file"
gzip = File.read(path)
tsv = ActiveSupport::Gzip.decompress(gzip)

tmp = Tempfile.new("type_attribs")
tmp.puts tsv
path = tmp.path

query = "LOAD DATA LOCAL INFILE '#{path}' into table type_attribs ( type_id, name, value );"
ActiveRecord::Migration.execute query

puts "Loading Regions"

file = "regions.tsv"
dir = Dir.pwd
path = dir + "/db/" + file

query = "LOAD DATA LOCAL INFILE '#{path}' into table regions ( id, name );"
ActiveRecord::Migration.execute query

puts "Loading Solar Systems"

file = "solar_systems.tsv"
dir = Dir.pwd
path = dir + "/db/" + file

query = "LOAD DATA LOCAL INFILE '#{path}' into table solar_systems ( id, cons_id, region_id, name );"
ActiveRecord::Migration.execute query

puts "Loading Constellations"

file = "constellations.tsv"
dir = Dir.pwd
path = dir + "/db/" + file

query = "LOAD DATA LOCAL INFILE '#{path}' into table cons ( id, region_id, name );"
ActiveRecord::Migration.execute query

puts "Creating Signature Groups"
[
  "Data Site",
  "Ore Site",
  "Gas Site",
  "Relic Site",
  "Wormhole",
  "Combat Site"
].each do |site_group|
  SigGroup.create(name: site_group)
end

puts "Creating Empty Signature Type"
SigType.create(name: "-")
