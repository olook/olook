class ChangeClippingTextTypeFromClippings < ActiveRecord::Migration
  def change
    change_column :clippings, :clipping_text, :text
  end
end
