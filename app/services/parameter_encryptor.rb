# -*- encoding : utf-8 -*-
module ParameterEncryptor
  PASS = "oasdifljkzh"

  def self.encrypt(str)
    secret = Digest::SHA1.hexdigest(PASS)
    a = ActiveSupport::MessageEncryptor.new(secret)
    CGI.escape(a.encrypt(str))    
  end

  def self.decrypt(str)
    unescaped_encrypted_id = CGI.unescape(str)
    secret = Digest::SHA1.hexdigest(PASS)
    c = ActiveSupport::MessageEncryptor.new(secret)
    c.decrypt(unescaped_encrypted_id)    
  end
end