class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.integer :video_relation_id
      t.string :video_relation_type

      t.timestamps
    end
  end
end
