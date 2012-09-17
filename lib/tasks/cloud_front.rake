namespace :product_images do
  desc "Invalidate all images on Cloudfront CDN"
  task :invalidate => :environment do
    Picture.all.each do |p|
      path = p.image.url.slice(23..150)
      CloudfrontInvalidator.new.invalidate(path)
      puts '.'
    end
  end
end
