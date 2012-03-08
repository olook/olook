class AddResumeToLiquidations < ActiveRecord::Migration
  def change
    add_column :liquidations, :resume, :text
  end
end
