# -*- encoding : utf-8 -*-
class BaseMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
end
