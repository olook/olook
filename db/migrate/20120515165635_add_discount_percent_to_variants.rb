class AddDiscountPercentToVariants < ActiveRecord::Migration
  def change
    add_column :variants, :discount_percent, :integer

  end
end
