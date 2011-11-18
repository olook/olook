class AddIndexToUserIdOnPoints < ActiveRecord::Migration
  def change
    add_index :points, :user_id
  end
end
