class Rat < ActiveRecord::Base
  has_many :type_attribs, foreign_key: :type_id
  has_many :drops
  belongs_to :site
  
  def missile
    missile_id = self.attrib "entityMissileTypeID"
    if missile_id
      missile_id.to_i
    else
      false
    end
  end
  
  def armor_repair
    amount = self.attrib "entityArmorRepairAmount"
    cycle = self.attrib "entityArmorRepairDuration"
    if ( amount and cycle ) and ( amount != 0 and cycle != 0)
      return amount / cycle * 1000
    end
  end

  def shield_boost
    amount = self.attrib "shieldCapacity"
    cycle = self.attrib "shieldRechargeRate"
    if ( amount and cycle ) and ( amount != 0 and cycle != 0)
      return amount / cycle * 1000
    end
  end
  
  def total_repair
    shield = self.shield_boost
    armor = self.armor_repair
    armor = 0 if armor.nil?
    shield = 0 if shield.nil?
    armor + shield
  end
    
  
  def total_hp
    hp = self.attrib("hp")
    hp ? hp : hp = 0
    armor = self.attrib("armorHP")
    armor ? armor : armor = 0
    shield = self.attrib("shieldCapacity")
    shield ? shield : shield = 0
    hp + armor + shield
  end
    
  def avg_res
    # {"shieldEmDamageResonance"=>30.0, "shieldExplosiveDamageResonance"=>25.0, "shieldKineticDamageResonance"=>15.000000000000002, "shieldThermalDamageResonance"=>20.0}
    # {"armorEmDamageResonance"=>60.0, "armorExplosiveDamageResonance"=>50.0, "armorKineticDamageResonance"=>30.000000000000004, "armorThermalDamageResonance"=>40.0}
    shield = self.shield_percent
    armor = self.armor_percent
    
    shield_keys = [ "shieldEmDamageResonance", "shieldExplosiveDamageResonance", "shieldKineticDamageResonance", "shieldThermalDamageResonance" ] 
    armor_keys = [ "armorEmDamageResonance", "armorExplosiveDamageResonance", "armorKineticDamageResonance", "armorThermalDamageResonance" ]
    
    shield_keys.each do |key|
      shield[key] = 0 if shield[key].nil?
    end
    armor_keys.each do |key|
      armor[key] = 0 if armor[key].nil?
    end
        
    {
      em: ( shield["shieldEmDamageResonance"] + armor["armorEmDamageResonance"] ) / 2,
      explosive: ( shield["shieldExplosiveDamageResonance"] + armor["armorExplosiveDamageResonance"]) / 2,
      kinetic: ( shield["shieldKineticDamageResonance"] + armor["armorKineticDamageResonance"]) / 2,
      thermal: ( shield["shieldThermalDamageResonance"] + armor["armorThermalDamageResonance"]) / 2
    }
  end
  
  def total_dps
    (self.gun_dps.sum + self.missile_dps.sum).to_f
  end
  
  def sum_dps
    self.gun_dps.values_add(self.missile_dps)
  end
  
  def shield_percent
    shield_res = self.attribs_like "shield%DamageResonance"
    out = {}
    if shield_res
      shield_res.each_pair do |key, value|
        tmp = { key => ( 1.0 - value ) * 100 }
        out.merge! tmp
      end
      out
    else
      {}
    end
  end

  def armor_percent
    armor_res = self.attribs_like "armor%DamageResonance"
    out = {}
    if armor_res
      armor_res.each_pair do |key, value|
        tmp = { key => ( 1.0 - value ) * 100 }
        out.merge! tmp
      end
      out
    else
      {}
    end
  end
  
  
  def missile_attribs 
    attribs = self.type_attribs.where("name like '%missile%'")
    if attribs.empty? == false
      missile_attribs = {}
      attribs.each do |row|
        tmp = { row["name"] => row["value"] }
        missile_attribs.merge! tmp
      end
      missile_attribs
    end
  end
  
  def gun_dps
    damage_multiplier = self.attrib "damageMultiplier"
    if damage_multiplier
      gun_dps = {}
      self.attribs_like("%damage").each_pair do |damage_type, dps|
        tmp = { damage_type => dps * damage_multiplier }
        gun_dps.merge! tmp
      end
      gun_dps
    else
      {}
    end
  end

  def attribs_like(arg)
    attribs = self.type_attribs.where("name like ?", arg)
    if attribs.empty? == false
      result_attribs = {}
      attribs.each do |row|
        tmp = { row["name"] => row["value"] }
        result_attribs.merge! tmp
      end
      result_attribs
    end
  end

  def attrib(arg)
    attrib = self.type_attribs.where(name: arg).first
    if attrib
      attrib.value
    end
  end


  def missile_dps
    missile = self.missile
    if missile 
      damage_multiplier = self.missile_attribs["missileDamageMultiplier"]
      damage_multiplier ? damage_multiplier : damage_multiplier = 1
      launch_duration = self.missile_attribs["missileLaunchDuration"]
      return {} if ( ! launch_duration or launch_duration == 1.0 or launch_duration == 0 )
      damage_types = {}
      TypeAttrib.where(type_id: missile).where("name like '%Damage'").each do |row|
        value = row["value"] * damage_multiplier / launch_duration * 1000
        tmp = { row["name"] => value }
        damage_types.merge! tmp
      end
      damage_types
    else
      {} 
    end
  end
end
