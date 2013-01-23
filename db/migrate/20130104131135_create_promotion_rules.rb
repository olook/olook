class CreatePromotionRules < ActiveRecord::Migration
  def change
    create_table :promotion_rules do |t|
      t.string :name
      t.string :type

      t.timestamps
    end
  end
end
