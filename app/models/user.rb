class User < ActiveRecord::Base
  has_many :keys
  has_many :chars
  has_many :wallet_records
  has_many :kills
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
end
