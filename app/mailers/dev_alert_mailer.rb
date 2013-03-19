# -*- encoding : utf-8 -*-
class DevAlertMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "dev notifications <dev@olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

  def braspag_capture_warn
    @warn_payments = BraspagAuthorizeResponse.find_by_sql("select p.id, a.identification_code, p.state, a.created_at from braspag_authorize_responses a left join braspag_capture_responses c  on a.identification_code = c.identification_code join payments p on a.identification_code = p.identification_code  where c.id is null and a.status = 1 and a.created_at > #{Time.zone.today - 5.days} and p.state <> 'cancelled' order by a.created_at desc")
    mail(:to => "incidentes@olook.com.br", :subject => "Pedidos que deveriam ter sido capturados pela braspag")
  end
end
