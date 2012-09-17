class AddAdminIdToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :admin_id, :integer

  end
end
