class Rat
  include Mongoid::Document
  embeds_many :rat_attributes
  validates :rat_id, :uniqueness => true
  field :rat_id, type: Integer
  field :bounty, type: Integer
  field :rat_name, type: String
  field :rat_type, type: String
  index({ rat_id: 1 }, { unique: true })
  index({ rat_name: 1 })
  index({ rat_name: -1 })

  def self.rat_name(id)
    rat = where(:rat_id => id).first
    if rat
      rat.rat_name
    else
      id.to_s
    end
  end
  def self.rat_type(id)
    rat = where(:rat_id => id).first
    if rat
      rat.rat_type
    else
      id.to_s
    end
  end
  def hps
    {
      shield: rat_attributes.where(name: "shieldCapacity").first.value,
      structure: rat_attributes.where(name: "hp").first.value,
      armor: rat_attributes.where(name: "armorHP").first.value
    }
  end
  def bounty
    rat_attributes.where(name: "entityKillBounty").first.value
  end
  def shield_res
    thermal = rat_attributes.where(name: "shieldThermalDamageResonance").first 
    thermal ? thermal = (1 - thermal.value ) * 100 : thermal = 0
    kinetic = rat_attributes.where(name: "shieldKineticDamageResonance").first 
    kinetic ? kinetic = (1 - kinetic.value ) * 100 : kinetic = 0
    explosive = rat_attributes.where(name: "shieldExplosiveDamageResonance").first 
    explosive ? explosive = (1 - explosive.value ) * 100 : explosive = 0
    em = rat_attributes.where(name: "shieldEmDamageResonance").first 
    em ? em = (1 - em.value ) * 100 : em = 0
    {
      kinetic: kinetic,
      thermal: thermal,
      explosive: explosive,
      em: em
    }
  end
  
  def armor_res
    kinetic = rat_attributes.where(name: "armorKineticDamageResonance").first.value
    kinetic ? kinetic = sprintf("%.0f", (1 - kinetic) * 100.0) : kinetic = 0
    thermal = rat_attributes.where(name: "armorThermalDamageResonance").first.value
    thermal ? thermal = sprintf("%.0f", (1 - thermal) * 100.0) : thermal = 0
    em = rat_attributes.where(name: "armorEmDamageResonance").first.value
    em ? em = sprintf("%.0f", (1 - em) * 100.0) : em = 0
    explosive = rat_attributes.where(name: "armorExplosiveDamageResonance").first.value
    explosive ? explosive = sprintf("%.0f", (1 - explosive) * 100.0) : explosive = 0
    {
      kinetic: kinetic,
      thermal: thermal,
      explosive: explosive,
      em: em
    }
  end
  
  def speed
    rat_attributes.where(name: "maxVelocity").first.value
  end
  
  def gun_dps
    multi = rat_attributes.where(name: "damageMultiplier").first
    rate = rat_attributes.where(name: "speed").first
    if multi and rate
      multi = multi.value 
      rate = rate.value / 1000
      kinetic = rat_attributes.where(name: "kineticDamage").first
      thermal = rat_attributes.where(name: "thermalDamage").first
      explosive = rat_attributes.where(name: "explosiveDamage").first
      em = rat_attributes.where(name: "emDamage").first
      {
        kinetic: kinetic ? kinetic.value * multi / rate : 0,
        thermal: thermal ? thermal.value * multi / rate : 0,
        explosive: explosive ? explosive.value * multi / rate : 0,
        em: em ? em.value * multi / rate : 0
      }
    else
      {
        kinetic: 0,
        thermal: 0,
        explosive: 0,
        em: 0
      }
    end
  end
  
  def missile_dps
    multi = rat_attributes.where(name: "missileDamageMultiplier").first
    if multi
      rate = rat_attributes.where(name: "missileLaunchDuration").first.value / 1000
      multi = multi.value
      missile = Charge.where(charge_id: rat_attributes.where(name: "entityMissileTypeID").first.value.to_i ).first
      {
        kinetic: missile.charge_attributes.where(name: "kineticDamage").first.value * multi / rate,
        thermal: missile.charge_attributes.where(name: "thermalDamage").first.value * multi / rate,
        explosive: missile.charge_attributes.where(name: "explosiveDamage").first.value * multi / rate,
        em: missile.charge_attributes.where(name: "emDamage").first.value * multi / rate,
        charge_name: missile.name
      }
    else
      {
        kinetic: 0,
        thermal: 0,
        explosive: 0,
        em: 0
      }
    end
  end

  def scram
    chance = rat_attributes.where(name: "entityWarpScrambleChance").first
    range = rat_attributes.where(name: "warpScrambleRange").first
    strength = rat_attributes.where(name: "warpScrambleStrength").first
    duration = rat_attributes.where(name: "warpScrambleDuration").first
    if chance and range and strength and duration
     chance != 0 ? chance = chance.value * 100 : 0
     range != 0 ? range = range.value : 0
     strength != 0 ? strength = strength.value : 0
     duration != 0 ? duration = (duration.value / 1000).to_s + "s" : 0
     return { chance: chance, range: range, strength: strength, duration: duration }
    else
     return nil
    end
  end

  def web
    chance = rat_attributes.where(name: "modifyTargetSpeedChance").first
    range = rat_attributes.where(name: "modifyTargetSpeedRange").first
    duration = rat_attributes.where(name: "modifyTargetSpeedDuration").first
    if chance and range and duration
     chance != 0 ? chance = chance.value * 100 : 0
     range != 0 ? range = range.value : 0
     duration != 0 ? duration = (duration.value / 1000).to_s + "s" : 0
     return { chance: chance, range: range, duration: duration }
    else
     return nil
    end
  end

  def neut
    chance = rat_attributes.where(name: "entityCapacitorDrainDurationChance").first
    range = rat_attributes.where(name: "entityCapacitorDrainMaxRange").first
    strength = rat_attributes.where(name: "entityCapacitorDrainAmount").first
    duration = rat_attributes.where(name: "entityCapacitorDrainDuration").first
    if chance and range and strength and duration
     chance != 0 ? chance = chance.value * 100 : 0
     range != 0 ? range = range.value : 0
     strength != 0 ? strength = strength.value : 0
     duration != 0 ? duration = (duration.value / 1000).to_s + "s" : 0
     return { chance: chance, range: range, strength: strength, durtaion: duration }
    else
     return nil
    end
  end

  def jam
    chance = rat_attributes.where(name: "entityTargetJamDurationChance").first
    range = rat_attributes.where(name: "entityTargetJamMaxRange").first
    falloff = rat_attributes.where(name: "entityTargetJamFallOff").first
    duration = rat_attributes.where(name: "entityTargetJamDuration").first
    if chance and range and falloff and duration
     chance != 0 ? chance = chance.value * 100 : 0
     range != 0 ? range = range.value : 0
     falloff != 0 ? falloff = falloff.value : 0
     duration != 0 ? duration = (duration.value / 1000).to_s + "s" : 0
     return { chance: chance, range: range, falloff: falloff, durtaion: duration }
    else
     return nil
    end
  end

  def damp
    chance = rat_attributes.where(name: "entitySensorDampenDurationChance").first
    range = rat_attributes.where(name: "entitySensorDampenMaxRange").first
    falloff = rat_attributes.where(name: "entitySensorDampenFallOff").first
    duration = rat_attributes.where(name: "entitySensorDampenDuration").first
    if chance and range and falloff and duration
     chance != 0 ? chance = chance.value * 100 : 0
     range != 0 ? range = range.value : 0
     falloff != 0 ? falloff = falloff.value : 0
     duration != 0 ? duration = (duration.value / 1000).to_s + "s" : 0
     return { chance: chance, range: range, falloff: falloff, durtaion: duration }
    else
     return nil
    end
  end
     
  def mobility
    cruise = rat_attributes.where(name: "entityCruiseSpeed").first 
    max = rat_attributes.where(name: "maxVelocity").first
    
    {
      orbit: rat_attributes.where(name: "entityFlyRange").first.value,
      cruise: cruise ? cruise.value : 0,
      max: max ? max.value : 0,
      range: rat_attributes.where(name: "entityAttackRange").first.value
    }
  end
end
