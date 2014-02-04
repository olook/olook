# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
  config.fog_credentials = {
    :provider => 'AWS'
  }
  # config.fog_directory = Rails.env.test? ? 'testcdn.olook.com.br' : 'cdn.olook.com.br'
  # config.fog_host = "http://#{config.fog_directory}"

  if Rails.env.test?
    config.fog_directory = 'testcdn.olook.com.br'
    config.fog_host = 'http://testcdn.olook.com.br'
  # elsif Rails.env.staging? || Rails.env.development?
  #   config.fog_directory = 'cdn-staging.olook.com.br'
  #   config.fog_host = proc do |file|
  #     "http://cdn-staging-#{rand(3)}.olook.com.br"
  #   end
  else
    config.fog_directory = 'cdn.olook.com.br'
    config.asset_host = Proc.new { |file|
      "https://gp1.wac.edgecastcdn.net/80BFF9/uploads"
    }
  end
  
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000',
                            'Expires' => 1.year.from_now.httpdate }
end
