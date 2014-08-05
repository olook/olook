class AddLastUsedAtToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :last_used_at, :datetime
  end
end
