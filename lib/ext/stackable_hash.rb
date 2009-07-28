class Hash
  def stackable
    StackableHash.new.replace(self)
  end
end

class StackableHash < Hash
  attr_accessor :parent, :current_key

  def child(key)
    hash = {key => StackableHash.new}.stackable
    new_target = self.current || self
    new_target.merge!(hash)
    new_target.current_key = key
    new_target.parent = self
    new_target
  end

  def <<(value)
    self[current_key] << value
  end

  def current=(value)
    self[current_key] = value
  end

  def current
    self[current_key]
  end

end