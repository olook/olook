# -*- encoding : utf-8 -*-
class AddBirthdayToUser < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
  end
end
