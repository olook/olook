class AddIntegrationDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :integration_date, :datetime
  end
end
