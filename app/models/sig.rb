class Sig < ActiveRecord::Base
  belongs_to :scan
  belongs_to :char
  belongs_to :corp
  belongs_to :system
  belongs_to :cons
  belongs_to :region
  belongs_to :alliance
  belongs_to :sig_type
  belongs_to :sig_group
end
