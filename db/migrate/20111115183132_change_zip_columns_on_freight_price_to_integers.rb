class ChangeZipColumnsOnFreightPriceToIntegers < ActiveRecord::Migration
  def change
    change_column :freight_prices, :zip_start, :integer
    change_column :freight_prices, :zip_end, :integer
  end
end
