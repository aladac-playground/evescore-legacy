class Badge
  include Mongoid::Document
  field :name, type: String
  field :text, type: String
  field :icon, type: String
  index({ name: 1 }, { unique: true, drop_dups: true })
  has_many :character_badges
end
