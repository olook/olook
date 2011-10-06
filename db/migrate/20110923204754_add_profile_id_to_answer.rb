# -*- encoding : utf-8 -*-
class AddProfileIdToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :profile_id, :integer
  end
end
