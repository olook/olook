# -*- encoding : utf-8 -*-
if defined?(AssetSync)
  AssetSync.configure do |config|
    config.enabled = true
    config.fog_provider = 'AWS'
    config.aws_access_key = 'AKIAJ2WH3XLYA24UTAJQ'
    config.aws_access_secret = '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'
    if Rails.env.staging?
      config.aws_bucket = 'cdn-app-staging'
    else
      config.aws_bucket = 'cdn-app'
    end

    # Increase upload performance by configuring your region
    config.aws_region = 'us-east-1'
    #
    # Don't delete files from the store
    config.existing_remote_files = "delete"
    #
    # Automatically replace files with their equivalent gzip compressed version
    config.gzip_compression = true
    #
    # Use the Rails generated 'manifest.yml' file to produce the list of files to 
    # upload instead of searching the assets directory.
    #config.manifest = true
    #
    # Fail silently.  Useful for environments such as Heroku
    # config.fail_silently = true
  end
end

