class AddBannerLabelToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :banner_label, :string
  end
end
