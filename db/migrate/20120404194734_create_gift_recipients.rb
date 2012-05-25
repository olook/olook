class CreateGiftRecipients < ActiveRecord::Migration
  def change
    create_table :gift_recipients do |t|
      t.references :user
      t.string :facebook_uid
      t.string :name
      t.integer :shoe_size
      t.references :gift_recipient_relation

      t.timestamps
    end
  end
end
