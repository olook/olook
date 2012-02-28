object @products
for product in @products
  attributes :id, :name, :description, :price
  node(:url) { "olook.com.br/product/" }
  node(:old_price) { "missing" }
  node(:url) { "olook.com.br/product/" }
end
