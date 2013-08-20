# -*- encoding : utf-8 -*-
Fog.mock!
Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
connection = Fog::Storage.new(:provider => 'AWS')
connection.directories.create(:key => 'testcdn.olook.com.br')
connection.directories.create(:key => 'olook-ftp-dev')
