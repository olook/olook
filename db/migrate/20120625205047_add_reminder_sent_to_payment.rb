class AddReminderSentToPayment < ActiveRecord::Migration
  def up
    add_column :payments, :reminder_sent, :boolean, :default => false
    say_with_time "Setting old billets reminders as sent..." do
      Billet.update_all(:reminder_sent => true)
    end
  end

  def down
    remove_column :payments, :reminder_sent
  end
end
