#!/usr/bin/env ruby

require_relative "config/boot"
require_relative "config/environment"

char = Char.where(name: "Adrian Dent").first
pp char

key = char.key

api = Eve::Api.new
api.key_id = key.id
api.vcode = key.vcode
api.character_id = char.id
api.row_count = 10

pp api.wallet_journal["eveapi"]["result"]["rowset"]["row"].first