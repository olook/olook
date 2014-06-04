class ChangeZipStartAndZipEndInShippingPolicies < ActiveRecord::Migration
  def change
    change_column :shipping_policies, :zip_start, :integer
    change_column :shipping_policies, :zip_end, :integer
  end
end
