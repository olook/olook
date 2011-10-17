# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => 'AKIAJ2WH3XLYA24UTAJQ',
    :aws_secret_access_key => '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',
  }
  config.fog_directory = 'olook'
end
