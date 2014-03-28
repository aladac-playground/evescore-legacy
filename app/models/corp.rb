class Corp < ActiveRecord::Base
  has_many :chars
  belongs_to :alliance

  def members_income
    ids = self.chars.ids
    w=WalletRecord.where(char_id: ids)
    w.top_income
  end
end
