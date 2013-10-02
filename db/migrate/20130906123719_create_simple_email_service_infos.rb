class CreateSimpleEmailServiceInfos < ActiveRecord::Migration
  def change
    create_table :simple_email_service_infos do |t|
      t.integer :bounces
      t.integer :complaints
      t.integer :delivery_attempts
      t.integer :rejects

      t.timestamps
    end
  end
end
