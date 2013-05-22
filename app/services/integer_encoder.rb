# -*- encoding : utf-8 -*-
module IntegerEncoder
  def self.encode(number)
    number.to_s(36)
  end

  def self.decode(str)
    str.to_i(36)
  end
end