class AddButtonPositionsToLandingPages < ActiveRecord::Migration
  def change
    change_table(:landing_pages) do |t|
      t.column :button_top, :integer
      t.column :button_left, :integer
    end
  end
end
