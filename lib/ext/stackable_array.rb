class StackableArray < Array
  attr_accessor :parent, :current_key

  def child(key)
    hash = {key => StackableHash.new}.stackable
    new_target = self.current
    new_target.merge!(hash)
    new_target.current_key = key
    new_target.parent = self
    new_target
  end

  def merge!(hash)
    if self.last.is_a?(Hash) && !self.last.key?(hash.keys.first)
      self.last.merge!(hash)
    else
      self << hash
    end
  end

  def current=(value)
    self.last[current_key] = value
  end

  def current
    self.last[current_key]
  end

end