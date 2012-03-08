class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.integer :user_id
      t.integer :shoes_size

      t.timestamps
    end
  end
end
