module RatsHelper
  def tracking_disrupt_chance
    chance = @rat.attrib("entityTrackingDisruptDurationChance")
    if chance 
      chance * 100
    else
      false
    end
  end
  
  def shield_boost
    @rat.shield_boost
  end
  
  def armor_repair
    @rat.armor_repair
  end

  def paint_chance
    chance = @rat.attrib("entityTargetPaintDurationChance")
    if chance 
      chance * 100
    else
      false
    end
  end
  
  def damp_chance
    chance = @rat.attrib("entitySensorDampenDurationChance")
    if chance 
      chance * 100
    else
      false
    end
  end

  def neut_chance
    chance = @rat.attrib("entityCapacitorDrainDurationChance")
    if chance 
      chance * 100
    else
      false
    end
  end

  def jam_chance
    chance = @rat.attrib("entityTargetJamDurationChance")
    if chance 
      chance * 100
    else
      false
    end
  end
  
  def web_chance
    chance = @rat.attrib("modifyTargetSpeedChance")
    if chance 
      chance * 100
    else
      false
    end
  end

  def scram_chance
    chance = @rat.attrib("entityWarpScrambleChance")
    if chance 
      chance * 100
    else
      false
    end
  end

  
  def gun_percent(kind)
    sum = @rat.gun_dps.sum
    percent = @rat.gun_dps.percent(sum)[kind]
    percent = 0 if percent.nil?
    progress(percent.round, damage_to_class(kind))
  end

  def missile_percent(kind)
    sum = @rat.missile_dps.sum
    percent = @rat.missile_dps.percent(sum)[kind]
    percent = 0 if percent.nil?
    progress(percent.round, damage_to_class(kind))
  end

  def dps_percent(kind)
    sum = @rat.missile_dps.sum + @rat.gun_dps.sum
    percent = @rat.sum_dps.percent(sum)[kind]
    percent = 0 if percent.nil?
    progress(percent.round, damage_to_class(kind))
  end
  
  def shield_percent_bar(kind)
    percent = @rat.shield_percent[kind]
    percent = 0 if percent.nil?
    progress(percent.round, damage_to_class(kind))
  end

  def armor_percent_bar(kind)
    percent = @rat.armor_percent[kind]
    percent = 0 if percent.nil?
    progress(percent.round, damage_to_class(kind))
  end
  
end
