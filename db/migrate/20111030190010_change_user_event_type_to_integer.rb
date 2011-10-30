class ChangeUserEventTypeToInteger < ActiveRecord::Migration
  def change
    change_column :events, :type, :integer, :null => false
  end
end
