class CreatePromotionActions < ActiveRecord::Migration
  def change
    create_table :promotion_actions do |t|
      t.string :type
      t.string :description

      t.timestamps
    end
  end
end
