class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :user
      t.string :email
      t.datetime :accepted_at
      t.integer :invited_member_id

      t.timestamps
    end
    add_index :invites, :user_id
    add_index :invites, :invited_member_id
  end
end
