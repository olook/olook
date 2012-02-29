collection @products
attributes :name, :tumb_picture, :showroom_picture, :description, :instock, :category, :price
node (:retailprice) { |product| product.price }
node (:recommendable) { '1' }
node (:url) { |product| product.product_url }
node (:smallimage) { |product| product.thumb_picture }
node (:bigimage) { |product| product.showroom_picture }
