class Wishlist < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user
  has_many :wished_products

  def add variant
    raise 'variant cannot be nil' if variant.nil?
    return false unless variant.valid?

    wished_products << WishedProduct.create({
      retail_price: variant.retail_price,
      variant_id: variant.id})
  end

  def remove variant_number
    to_be_deleted = find_wished_product_by(variant_number)
    deleted = wished_products.delete(to_be_deleted)
    deleted.any?
  end

  def self.for(user)
    where(user_id: user.id).first || Wishlist.new({user_id: user.id})
  end

  private
    def find_wished_product_by variant_number
      wished_products.select{|wp| wp.variant.number == variant_number}
    end
end
