# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
  config.fog_credentials = {
    :provider => 'AWS'
  }
  #config.fog_directory = Rails.env.test? ? 'testcdn.olook.com.br' : 'cdn.olook.com.br'
  #config.fog_host = "http://#{config.fog_directory}"

  if Rails.env.test?
    config.fog_host = 'http://testcdn.olook.com.br'
  elsif Rails.env.production? || Rails.env.development?
    config.fog_host = proc do |file|
      "http://cdn-#{rand(3)}.olook.com.br"
    end
  else
    config.fog_host = proc do |file|
      "http://cdn-staging-#{rand(3)}.olook.com.br"
    end
  end
  
  config.fog_attributes = { 'Cache-Control' => 'max-age=315576000',
                            'Expires' => 1.year.from_now.httpdate }
end

# https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Specify-the-image-quality
module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage)
        img = yield(img) if block_given?
        img
      end
    end
  end
end
