class CreatePermissions < ActiveRecord::Migration
 def change
    create_table :permissions do |t|
      t.string :model_name
      t.string :action_name
      t.timestamps
    end
  end
end
