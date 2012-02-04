class AddParamToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :param, :string
  end
end
