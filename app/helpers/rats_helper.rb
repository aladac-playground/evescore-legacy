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
end
