class NumericParser
  def self.parse_float float_value
    BigDecimal.new(float_value.gsub(/[^\d,\.]/, '').gsub(',','.'), 10)
  end  
end