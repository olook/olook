class CreateActionParameters < ActiveRecord::Migration
  def change
    create_table :action_parameters do |t|
      t.integer :promotion_id
      t.integer :promotion_action_id
      t.string :param

      t.timestamps
    end
  end
end
