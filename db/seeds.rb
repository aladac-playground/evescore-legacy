# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

# rats = YAML.load_file("rats.yml")
# rats.each do |rat|
#   b = Rat.new(rat)
#   b.save
# end
# 
# badges = YAML.load_file("badges.yml")
# badges.each do |badge|
#   b = Badge.new
#   b.save
# end
# 
rat_data = YAML.load_file("rat_data.yml")
rat_data.each_pair do |rat_id, data|
  rat = Rat.where(rat_id: rat_id).first
  data.each_pair do |k,v|
    rat.rat_attributes.new(name: k, value: v)
    rat.save
  end
end

charges = YAML.load_file("charges.yml")
charges.each_pair do |charge_id, data|
  charge = Charge.new(name: data["name"], type: data["type"], charge_id: charge_id.to_i)
  charge.save
  data["attribs"].each_pair do |k, v|
    charge.charge_attributes.new(name: k, value: v)
    charge.save
  end
end
  

# chars = YAML.load_file("characters.yml")
# chars.each do |char|
#   b = Character.new(char)
#   b.save
# end

# kills = YAML.load_file("kills.yml")
# i=0
# kills.each do |kill|
#   next if kill[:rat_id] == 0
#   bounty = Rat.where(rat_id: kill[:rat_id]).first.bounty
#   kill.merge!(:bounty => bounty)
#   kill.merge!(:id => { :ts => kill[:ts], :rat_id => kill[:rat_id], :char_id => kill[:char_id] })
#   p kill
#   b = Kill.new(kill)
#   b.save
# end

# bounties = YAML.load_file("bounties.yml")
# bounties.each do |bounty|
#   b = Bounty.new(bounty)
#   p b
#   b.save
# end
