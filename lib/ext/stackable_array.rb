class StackableArray < Array
  attr_accessor :parent, :current_key

  def merge!(hash)
    self << hash
  end

  def current=(value)
    self.last[self.current_key] = value
  end

  def current
    self.last[self.current_key] || self.last
  end

end