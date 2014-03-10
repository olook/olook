class AddOnePerUserToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :one_per_user, :boolean
  end
end
