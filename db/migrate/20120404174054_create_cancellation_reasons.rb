class CreateCancellationReasons < ActiveRecord::Migration
  def change
    create_table :cancellation_reasons do |t|
      t.integer :source
      t.integer :order_id
      t.text :message

      t.timestamps
    end
  end
end
