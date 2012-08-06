class AddCreatedByAndUpdatedByToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :created_by, :string
    add_column :coupons, :updated_by, :string
  end
end
