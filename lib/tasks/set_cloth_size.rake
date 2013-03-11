# -*- encoding : utf-8 -*-
namespace :db do

  desc "Updates catalog shoes with heel and heel_label equals nil"
  task :update_catalog_products_cloth_size => :environment do
  Catalog::Product.where(category_id: Category::CLOTH).each do |cp|
      begin
       description = cp.variant.description
       cp.update_attributes(cloth_size: description)
       puts "Catalog Product [#{ cp.id }] updated"
      rescue Exception => e
        puts "Error on updating cloth_size info of product [#{cp.product_id}]: #{e.message}"
        next
      end
  end
end
end
