class Drop < ActiveRecord::Base
  belongs_to :rat
  validates_uniqueness_of :name, scope: :rat_id
  
  scope :guaranteed, -> {
    where(guaranteed: true)
  }
  
  scope :random, -> {
    where("guaranteed is null or guaranteed <> 1")
  }
end
