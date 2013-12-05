class Freebie
  def initialize(attrs={})
    @subtotal = attrs[:subtotal]
  end

  def can_receive_freebie?
    @subtotal.to_f > 200
  end

end
