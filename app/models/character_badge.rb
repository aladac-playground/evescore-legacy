class CharacterBadge
  include Mongoid::Document
  belongs_to :character
  belongs_to :badge
end
