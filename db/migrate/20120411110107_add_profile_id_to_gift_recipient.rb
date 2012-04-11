class AddProfileIdToGiftRecipient < ActiveRecord::Migration
  def change
    add_column :gift_recipients, :profile_id, :integer
  end
end
