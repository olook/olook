# -*- encoding : utf-8 -*-
class ChangeDisplayOnPictureFieldToInteger < ActiveRecord::Migration
  def change
    change_column :pictures, :display_on, :integer
  end
end
