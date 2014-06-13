class Wishlist < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user
  has_many :wished_products

  def add variant
    raise 'variant cannot be nil' if variant.nil?
    return false unless variant.valid?

    wp = wished_products.build({
      retail_price: variant.retail_price,
      wishlist_id: self.id,
      variant_id: variant.id})
    wp.save
  end

  def remove variant_number
    to_be_deleted = wished_products.joins(:variant).where(Variant.arel_table[:number].eq(variant_number))
    deleted = wished_products.delete(to_be_deleted)
    deleted.any?
  end

  def self.for(user)
    where(user_id: user.id).first || Wishlist.create({user_id: user.id})
  end

  def has? product_id
    products.map{|wp| wp.product_id}.include?(product_id)
  end

  def products
    wished_products.first(60).select{|wp| wp.is_visible?}
  end

  def size
    products.size
  end
end
