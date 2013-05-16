# -*- encoding : utf-8 -*-
module ParameterEncoder
  def self.encode(str)
     ActiveSupport::Base64.encode64(str).strip   
  end

  def self.decode(str)
    ActiveSupport::Base64.decode64(str)
  end
end