class AddDateAndRecipientRelationToGiftOccasionTypes < ActiveRecord::Migration
  def change
    add_column :gift_occasion_types, :day, :integer

    add_column :gift_occasion_types, :month, :integer

    add_column :gift_occasion_types, :gift_recipient_relation_id, :integer
    
    add_index :gift_occasion_types, :gift_recipient_relation_id 
  end
end
