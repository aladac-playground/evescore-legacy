class Alliance < ActiveRecord::Base
  has_many :corps
  has_many :chars
  has_many :wallet_records  
end
