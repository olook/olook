class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.references :user
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_content
      t.string :utm_campaign
      t.string :gclid
      t.timestamps
    end

    add_index :trackings, :user_id
    add_index :trackings, :utm_content
  end
end
