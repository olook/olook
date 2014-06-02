class Freight::FreeCostPolicy

  def self.apply?(shipping_policies, cost)
    return false if shipping_policies.blank?
    cost > shipping_policies.first.free_shipping.to_d
  end
end
