class RemoveRoleFromAdmin < ActiveRecord::Migration
  def up
    remove_column :admins, :role
  end

  def down
    add_column :admins, :role, :string
  end
end
