class Allied < ActiveRecord::Base
  validates_uniqueness_of :corp_id, scope: :alliance_id
  
  def self.alliance_name(id)
    allied = where(corp_id: id).first
    alliance = Alliance.find(allied.alliance_id)
    alliance.name if alliance
  end
end
