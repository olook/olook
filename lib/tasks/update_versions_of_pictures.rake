# -*- encoding : utf-8 -*-
namespace :db do

  desc "Updates recreate version of pictures"
  task :update_version_of_pictures => :environment do
    #TODO change date
    Product.where("created_at > date('#{Date.today-100.day}')").each do |product|
      begin
        update_versions_of(product.main_picture)
        update_versions_of(product.pictures.where(display_on: 2).first)
        update_versions_of(product.pictures.order('display_on desc').first)
     rescue
       next
     end
    end
  end

  private
     def update_versions_of(picture)
       new_image = picture.image
       new_image.recreate_versions!
       image_address = URI.parse(new_image.to_s).to_s.match("image-(.*)").to_s
       sql = "UPDATE `pictures` SET `image` = '#{ image_address }', `updated_at` = '#{DateTime.now}' WHERE `pictures`.`id` = #{ picture.id }"
       ActiveRecord::Base.connection.execute(sql)
     end
end
