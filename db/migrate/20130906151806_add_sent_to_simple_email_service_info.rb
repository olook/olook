class AddSentToSimpleEmailServiceInfo < ActiveRecord::Migration
  def change
    add_column :simple_email_service_infos, :sent, :date
  end
end
