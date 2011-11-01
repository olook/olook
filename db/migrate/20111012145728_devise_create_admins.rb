# -*- encoding : utf-8 -*-
class DeviseCreateAdmins < ActiveRecord::Migration
  def self.up
    create_table(:admins) do |t|
      t.database_authenticatable :null => false
      t.lockable
      t.trackable
      t.rememberable
      t.timestamps
    end

    add_index :admins, :email, :unique => true
  end

  def self.down
    drop_table :admins
  end
end
