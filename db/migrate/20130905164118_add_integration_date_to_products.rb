class AddIntegrationDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :integration_date, :date
  end
end
