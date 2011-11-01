# -*- encoding : utf-8 -*-
class AddIndexToInviteEmail < ActiveRecord::Migration
  def change
    add_index :invites, :email
  end
end
