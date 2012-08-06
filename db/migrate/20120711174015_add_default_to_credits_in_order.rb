class AddDefaultToCreditsInOrder < ActiveRecord::Migration
  def change
    change_column_default :orders, :credits, 0
  end
end