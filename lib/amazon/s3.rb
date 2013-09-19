module Amazon
  module S3
    def self.send_to_amazon (file,path)
      bucket = ENV["RAILS_ENV"] == 'production' ? 'cdn-app' : 'cdn-app-staging'
      connection = Fog::Storage.new({
        :provider   => 'AWS'
      })
      directory = connection.directories.get(bucket)
      directory.files.create(
        :key    => path,
        :body   => file,
        "Content-Type" => "application/xml",
        :public => true)
    end
  end
end
