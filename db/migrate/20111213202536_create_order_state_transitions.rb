class CreateOrderStateTransitions < ActiveRecord::Migration
  def change
    create_table :order_state_transitions do |t|
      t.references :order
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :order_state_transitions, :order_id
  end
end
