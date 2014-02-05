class AddResellerInfoToUsers < ActiveRecord::Migration
  def change
    change_table :users do |u|
      u.string :corporate_name
      u.string :cnpj
      u.boolean :reseller, default: false
      u.boolean :active
    end
  end
end
