class AddRankedProfileIdsToGiftRecipient < ActiveRecord::Migration
  def change
    add_column :gift_recipients, :ranked_profile_ids, :text

  end
end
