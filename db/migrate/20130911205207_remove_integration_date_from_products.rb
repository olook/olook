class RemoveIntegrationDateFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :integration_date
  end
end
