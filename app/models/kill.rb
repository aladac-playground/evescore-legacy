class Kill < ActiveRecord::Base
  belongs_to :char
  belongs_to :corp
  belongs_to :alliance
  belongs_to :wallet_record
  belongs_to :user
  validates_uniqueness_of :ts, scope: [ :char_id, :rat_id ]
  
  scope :non_anon, -> {
    where("anon <> 1 or anon is null")
  }
  
  scope :this_month, -> {
    where("ts >= '#{Time.now.beginning_of_month}'")
  }

  scope :last_ten_days, -> {
    where("ts >= '#{Time.now - 10.days}'")
  }

  scope :top_kills, -> {
    non_anon
    .select("sum(rat_amount) as amount, char_id as id, char_name as name")
    .group(:char_id)
    .order("sum(rat_amount) desc")
  }
  scope :top_rats, -> {
    select("sum(rat_amount) as amount, rat_id as id, rat_name as name")
    .group(:rat_id)
    .order("sum(rat_amount) desc")
  }
  scope :overseer, -> {
    where("rat_type like '%overseer%'")
  }
  scope :type_like, -> (rat_type) {
    where("rat_type like '%#{rat_type}%'")
  }
end
