class Array
  def to_h(keys)
    Hash[*keys.zip(self).flatten]
  end
end