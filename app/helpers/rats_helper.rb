module RatsHelper
  def missile_damage
    if @rat.missile_dps
      missile_damage = Hash.new
      @rat.missile_dps.each_pair do |k, v|
        next if k == :charge_name
        missile_damage[k] = sprintf "%.2f", v
      end
    end
    missile_damage
  end
  def gun_damage
    if @rat.gun_dps
      gun_damage = Hash.new
      @rat.gun_dps.each_pair do |k, v|
        gun_damage[k] = sprintf "%.2f", v
      end
    end
    gun_damage
  end
  def total_damage
    total_damage = Hash.new
    @rat.gun_dps.each_pair do |k, v|
      total_damage[k] = v
    end
    @rat.missile_dps.each_pair do |k, v|
      next if k == :charge_name
      total_damage[k] = sprintf "%.2f", total_damage[k] + @rat.missile_dps[k]
    end
    total_damage
  end
  def mobility
    mobility = {
      # number_to_currency(1234567890.50, unit: "&pound;", separator: ",", delimiter: "", format: "%n %u")
      orbit: number_to_currency(@rat.mobility[:orbit], precision: 0, delimiter: ",", format: "%n %u", unit: "m"),
      max: number_to_currency(@rat.mobility[:max], precision: 0, delimiter: ",", format: "%n %u", unit: "m/s"),
      cruise: number_to_currency(@rat.mobility[:cruise], precision: 0, delimiter: ",", format: "%n %u", unit: "m/s"),
      range: number_to_currency(@rat.mobility[:range], precision: 0, delimiter: ",", format: "%n %u", unit: "m")
    }
  end
  def extras(rat)
    jam = rat.jam
    scram = rat.scram
    web = rat.web
    neut = rat.neut
    damp = rat.damp
    if scram
      scram
      # image_tag "icons/scramble.png", { style: "height: 32px", class: "ttp", 
      #   title: "<b>Warp Scram</b><br>Strength: #{scram[:strength]}<br>Range: #{scram[:range]}<br>Chance: #{scram[:chance]}%<br>Duration: #{scram[:duration]}" }
    end
    if web
      image_tag "icons/web.png", { style: "height: 32px", class: "ttp", 
        title: "<b>Stasis Webefier</b><br>Range: #{web[:range]}<br>Chance: #{web[:chance]}%<br>Duration: #{web[:duration]}" }
    end
    if neut
      image_tag "icons/neut.png", { style: "height: 32px", class: "ttp", 
        title: "<b>Energy Neutralizer</b><br>Strength: #{neut[:strength]}<br>Range: #{neut[:range]}<br>Chance: #{neut[:chance]}%<br>Duration: #{neut[:duration]}" }
    end
    if jam
      image_tag "icons/jam.png", { style: "height: 32px", class: "ttp", 
        title: "<b>Target Jammer</b><br>Strength: #{jam[:falloff]}<br>Range: #{jam[:range]}<br>Chance: #{jam[:chance]}%<br>Duration: #{jam[:duration]}" }
    end
    if damp
      image_tag "icons/damp.png", { style: "height: 32px", class: "ttp", 
        title: "<b>Target Jammer</b><br>Strength: #{damp[:falloff]}<br>Range: #{damp[:range]}<br>Chance: #{damp[:chance]}%<br>Duration: #{damp[:duration]}" }
    end    
  end
end
