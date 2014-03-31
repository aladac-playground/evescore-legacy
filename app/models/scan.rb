class Scan < ActiveRecord::Base
  belongs_to :char
  belongs_to :corp
  belongs_to :alliance
  # before_create :assign_secure_id
  has_many :sigs
  
  # private
  # def assign_secure_id
  #   self.secure_id = SecureRandom.hex
  # end
end
