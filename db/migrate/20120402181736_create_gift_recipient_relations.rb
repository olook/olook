class CreateGiftRecipientRelations < ActiveRecord::Migration
  def change
    create_table :gift_recipient_relations do |t|
      t.string :name

      t.timestamps
    end
  end
end
