class Key < ActiveRecord::Base
  belongs_to :user
  has_many :chars, dependent: :destroy
  # validates_format_of :vcode, :with => /\A[a-zA-Z0-9]{64}\Z/
  # validates_format_of :id, :with => /\A\d{7}\Z/
  validate :key_all_in_one

  def key_all_in_one
    if self.id.to_s !~ /^\d*$/
      errors.add(:id, "is in invalid format")
      return true
    end
    if ! self.vcode or self.vcode.empty?
      errors.add(:vcode, "cannot be empty")
      return true
    end
    begin
      info = self.api_key_info["eveapi"]["result"]["key"].rubify
    rescue
      errors.add(:key, "Cannot access key")
    end
    expires = info[:expires]
    key_type = info[:type]
    if ! expires.empty?
      expires = Time.parse(expires)
    end
    mask = info[:access_mask].to_i
    if ( 2097152 & mask ) == 0
      errors.add(:key, "must allow Wallet Journal access")
    else
      self.working = true
      self.mask = mask
      self.expires = expires
      self.key_type = key_type
    end
  end
  
  def api_key_info
    self.api.api_key_info
  end
  
  def api
    api = Eve::Api.new
    api.key_id = self.id
    api.vcode = self.vcode
    api
  end
  
  def get_chars
    api_chars = self.api.characters
    out = []
    begin
      chars = api_chars["eveapi"]["result"]["rowset"]["row"]
      chars.each do |char|
        out.push char.rubify
      end
    rescue
      return nil
    end
    out.empty? ? nil : out
  end
  
  def wallet_import
    self.api.wallet_journal.wallet_import
  end
  
  def import_chars(user_id)
    self.get_chars.each do |char|
      allied = Allied.where(corp_id: char[:corporation_id]).first
      if allied
        alliance_id = allied.alliance_id
        alliance_name = Alliance.find(alliance_id).name
      else
        alliance_id = nil
      end
      corp=Corp.create(id: char[:corporation_id], name: char[:corporation_name], alliance_id: alliance_id, alliance_name: alliance_name)
      c = Char.where(id: char[:character_id]).first
      if c
        c.key_id = self.id
        c.user_id = user_id
        c.save
      else
        Char.create(id: char[:character_id], name: char[:name], corp_id: char[:corporation_id], key_id: self.id, user_id: self.user_id, alliance_id: alliance_id, alliance_name: alliance_name, corp_name: char[:corporation_name])
      end
    end
  end
end
