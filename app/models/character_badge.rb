class CharacterBadge
  include Mongoid::Document
  belongs_to :character
  belongs_to :badge
  index({  character_id: 1, badge_id: 1 }, { unique: true, drop_dups: true })
end
