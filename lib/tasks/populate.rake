# -*- encoding : utf-8 -*-
namespace :db do
  task :populate => :environment  do
    destroy_products
    create_products
  end
end

def create_products
  names = %w(Chanelle Scarpan Charmant Mezzo Viamarte Scala Champions Deluxe SantRo)
  10.times do |p_id|
    current_name = names[rand(names.size)]
    puts "!!!! #{p_id} - #{current_name}"
    product = Product.create(:name => current_name, :description => "#{current_name} description", :category => Category::SHOE, :model_number => 'CHS#{p_id}')
    4.times do |i|
      product.variants.create(:is_master => false,
                          :number => 35 + i,
                          :description => 'size 35',
                          :display_reference => 'size-35',
                          :price => 123.46 + i,
                          :inventory => 10,
                          :width => 1,
                          :height => 1,
                          :length => 1,
                          :weight => 1.0)
    end
  end

end

def destroy_products
  Product.delete_all
  Variant.unscoped.delete_all
end



