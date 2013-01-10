class RenameTypeToActionTypeOnPromotionActions < ActiveRecord::Migration
  def change
    change_table :promotion_actions do |t|
      t.rename :type, :action_type
    end
  end
end
