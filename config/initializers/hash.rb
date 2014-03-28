class Hash
  def sum
    (self.inject(0) { |sum, tuple| sum += tuple[1] }).to_f
  end
  def percent(sum)
    out = {}
    if sum == 0 
      return self
    else
      self.each_pair do |key, value|
        tmp = { key => value / sum * 100.0 }
        out.merge! tmp
      end
      out
    end
  end
  def values_add(hash)
    out = {}
    if self.empty?
      return hash
    elsif hash.empty?
      return self
    else      
      self.each_pair do |key, value|
        hash[key] ? add = hash[key] : add = 0
        tmp = { key => value + add }
        out.merge! tmp
      end
      return out
    end
  end
  def avg(hash)
    out = {}
    self.each_pair do |key, value|
      hash[key] ? add = hash[key] : add = 0
      tmp = { key => ( value + add ) / 2 }
      out.merge! tmp
    end
    out
  end
end