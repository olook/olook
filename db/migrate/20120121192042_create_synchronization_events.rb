class CreateSynchronizationEvents < ActiveRecord::Migration
  def change
    create_table :synchronization_events do |t|
      t.string :name

      t.timestamps
    end
  end
end
