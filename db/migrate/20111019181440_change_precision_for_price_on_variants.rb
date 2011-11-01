# -*- encoding : utf-8 -*-
class ChangePrecisionForPriceOnVariants < ActiveRecord::Migration
  def change
    change_column :variants, :price, :decimal, :precision => 10, :scale => 2
  end
end
