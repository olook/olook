class AddColumnNameToPromotionAction < ActiveRecord::Migration
  def change
    add_column :promotion_actions, :name, :string
  end
end
