# -*- encoding : utf-8 -*-
class AddSentAtToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :sent_at, :datetime
  end
end
