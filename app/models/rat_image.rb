class RatImage < ActiveRecord::Base
  validates_uniqueness_of :rat_id, scope: :size
end
