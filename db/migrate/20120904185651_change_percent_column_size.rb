class ChangePercentColumnSize < ActiveRecord::Migration
  def up
    change_column :payments, :percent, :decimal, :precision => 8, :scale => 2
  end

  def down
    change_column :payments, :percent, :decimal, :precision => 3, :scale => 2
  end
end