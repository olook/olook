module BraspagHelper

  def string_to_currency(value)
    number_to_currency(value.to_i/100.00)
  end

end
