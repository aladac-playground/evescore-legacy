require_relative "config/boot"
require_relative "config/environment"

scan = Scan.first

sys = SolarSystem.last

scan.sigs.where(system_id: nil).each do |sig|
  sig.system_id = sys.id
  sig.region_id = sys.region_id
  sig.cons_id = sys.cons_id
  sig.save
end