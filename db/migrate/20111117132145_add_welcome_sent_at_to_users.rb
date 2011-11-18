class AddWelcomeSentAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcome_sent_at, :datetime
  end
end
