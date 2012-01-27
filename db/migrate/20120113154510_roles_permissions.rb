class PermissionsRoles < ActiveRecord::Migration
create_table :permissions_roles, :id => false do |t|
  t.references :permission, :role
end
end
