#!/usr/bin/env ruby

require_relative "config/boot"
require_relative "config/environment"

s=File.readlines("sample-sigs.txt")

solar_system_id = 30000001

s.each do |line|
  # IMY-400	Cosmic Signature	Data Site	Central Guristas Sparking Transmitter	100,00%	31,51 AU
  if line =~ /^(\w{3}-\d{3})\t.*\t(.*)\t(.*)\t(.*)\t(.*)$/
    scan_id = $1
    sig_group = $2
    sig_type = $3
    # Sig(id: integer, scan_id: integer, char_id: integer, corp_id: integer, system_id: integer, cons_id: integer, region_id: integer, alliance_id: integer, sig_type_id: integer, sig_group_id: integer, created_at: datetime, updated_at: datetime)
    sig=Sig.new( scan_id: )
  end
end
    
