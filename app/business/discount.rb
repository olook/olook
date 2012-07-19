class Discount
  attr_accessor :origin , :value , :percentage, :item

  def initialize(params)
    params.each_pair do |key, value|
      send(key.to_s+'=',value)
    end

    if @value
      percentage_factor = (@value / item.original_price)
    elsif @percentage
      @value = item.original_price * percentage_factor
    else
      @value = @percentage = 0
    end
  end

  def percentage_factor=(factor)
    @percentage = ( 1 - factor ) * 100.0
  end

  def percentage_factor
    1 - (@percentage / 100.0)
  end
end
