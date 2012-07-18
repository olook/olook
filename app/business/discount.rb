class Discount
  attr_accessor :origin , :value , :percentage, :item

  def initialize(params)
    params.each_pair do |key, value|
      self.send(key.to_s+'=',value)
    end

    if @value
      @percentage = (@value / item.original_price) * 100
    elsif @percentage
      @value = item.original_price * percent_factor
    else
      @value = @percentage = 0
    end
  end

  def percent_factor
    (@percentage / 100.0)
  end
end
