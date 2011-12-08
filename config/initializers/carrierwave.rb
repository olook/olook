# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
  config.fog_credentials = {
    :provider => 'AWS'
  }
  
  if Rails.env.production?
    config.fog_directory = 'cdn.olook.com.br'
  else
    config.fog_directory = 'testcdn.olook.com.br'
  end
    
  config.fog_host = "http://#{config.fog_directory}"
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
