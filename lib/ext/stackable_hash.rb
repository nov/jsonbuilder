class StackableHash < Hash
  attr_accessor :parent, :current_key

  def child(key)
    hash = StackableHash.new.replace(key => StackableHash.new)

    new_target = if self.current.is_a?(Array) && !self.current.empty? && !self.current.last.key?(key)
      self.current.last
    else
      self.current
    end  
    new_target.merge!(hash)
    new_target.current_key = key
    new_target.parent = self
    new_target
  end

  def <<(value)
    self.current = value
  end

  def current=(value)
    if self.current.is_a?(Array)
      self[self.current_key] << value
    else
      self[self.current_key] = value
    end
  end

  def current
    self[self.current_key] || self
  end

end