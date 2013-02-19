# -*- encoding : utf-8 -*-
namespace :db do

  desc "Updates catalog shoes with heel and heel_label equals nil"
  task :update_rake_catalog_products_heels, [:catalog_id] => :environment do |t, args|
    Catalog::Catalog.find(args[:catalog_id]).products.where(category_id: Category::SHOE).each do |cp|
      begin
        if cp.heel.nil? && cp.heel_label.nil? && cp.product.heel
          heel_label = cp.product.heel
          heel = cp.product.heel.gsub(" ","-")
          cp.update_attributes(heel: heel, heel_label: heel_label)
          puts "Catalog Product #{ cp.id } updated!"
        end
      rescue Exception => e
        puts "Error on updating heel info of product [#{cp.product_id}]: #{e.message}"
        next
      end
    end
  end
end
