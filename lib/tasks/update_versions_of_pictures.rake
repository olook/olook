# -*- encoding : utf-8 -*-
namespace :db do

  desc "Updates recreate version of pictures"
  task :update_version_of_pictures => :environment do
    #TODO change date
    Product.where("created_at > date('#{Date.today-100.day}')").each do |product|
      begin
        new_image = product.main_picture.image
        new_image.recreate_versions!
        image_address = URI.parse(new_image.to_s).to_s.match("image-(.*)").to_s
        sql = "UPDATE `pictures` SET `image` = '#{ image_address }', `updated_at` = '#{DateTime.now}' WHERE `pictures`.`id` = #{ product.main_picture.id }"
        ActiveRecord::Base.connection.execute(sql)
      rescue
        next
      end
    end
  end
end
