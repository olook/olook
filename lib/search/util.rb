module Search
  module Util
    def self.encode(str)
      str.gsub!(' ', '%20')
      str.gsub!("'", '%27')
      str.gsub!("+", '%2B')
      str
    end
  end
end
