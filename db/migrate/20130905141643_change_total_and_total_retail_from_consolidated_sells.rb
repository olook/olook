class ChangeTotalAndTotalRetailFromConsolidatedSells < ActiveRecord::Migration
  def change
    change_column :consolidated_sells, :total, :decimal, :precision => 8, :scale => 2
    change_column :consolidated_sells, :total_retail, :decimal, :precision => 8, :scale => 2
  end
end
