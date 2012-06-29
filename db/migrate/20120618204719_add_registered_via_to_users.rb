class AddRegisteredViaToUsers < ActiveRecord::Migration
  require 'user'
  def change
    add_column :users, :registered_via, :integer, :default => 0
    User.where(:half_user => true).each do |user|
      user.registered_via = 1
      user.save
    end
  end
end
