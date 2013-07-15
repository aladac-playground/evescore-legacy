class Rat
  include Mongoid::Document
  embeds_many :rat_attributes
  validates :rat_id, :uniqueness => true
  field :rat_id, type: Integer
  field :bounty, type: Integer
  field :rat_name, type: String
  field :rat_type, type: String
  index({ rat_id: 1 }, { unique: true })
  index( { "rat_attribute.name" => 1 }, { unique: true, drop_dups: true })

  def self.rat_name(id)
    where(:rat_id => id).first.rat_name
  end
  def self.rat_type(id)
    where(:rat_id => id).first.rat_type
  end
  def hps
    {
      shield: rat_attributes.where(name: "shieldCapacity").first.value,
      structure: rat_attributes.where(name: "hp").first.value,
      armor: rat_attributes.where(name: "armorHP").first.value
    }
  end
  def shield_res
    {
      kinetic: (1 - rat_attributes.where(name: "shieldKineticDamageResonance").first.value) * 100,
      thermal: (1 - rat_attributes.where(name: "shieldThermalDamageResonance").first.value) * 100,
      explosive: (1 - rat_attributes.where(name: "shieldExplosiveDamageResonance").first.value) * 100,
      em: (1 - rat_attributes.where(name: "shieldEmDamageResonance").first.value) * 100,
    }
  end
  def armor_res
    {
      kinetic: (1 - rat_attributes.where(name: "armorKineticDamageResonance").first.value) * 100,
      thermal: (1 - rat_attributes.where(name: "armorThermalDamageResonance").first.value) * 100,
      explosive: (1 - rat_attributes.where(name: "armorExplosiveDamageResonance").first.value) * 100,
      em: (1 - rat_attributes.where(name: "armorEmDamageResonance").first.value) * 100,
    }
  end
  def speed
    rat_attributes.where(name: "maxVelocity").first.value
  end
  def gun_dps
    multi = rat_attributes.where(name: "damageMultiplier").first.value
    {
      kinetic: rat_attributes.where(name: "kineticDamage").first.value * multi,
      thermal: rat_attributes.where(name: "thermalDamage").first.value * multi,
      explosive: rat_attributes.where(name: "explosiveDamage").first.value * multi,
      em: rat_attributes.where(name: "emDamage").first.value * multi
    }
  end
end
