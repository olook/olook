# -*- encoding : utf-8 -*-
class AddIsInvitedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_invited, :boolean
  end
end
