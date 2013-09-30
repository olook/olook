class CreateLiveFeeds < ActiveRecord::Migration
  def change
    create_table :live_feeds do |t|
      t.string :firstname
      t.string :gender
      t.date :birthdate
      t.string :email
      t.string :ip
      t.integer :question
      t.string :zip
      t.string :lastname

      t.timestamps
    end
  end
end