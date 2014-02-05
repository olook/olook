class AddYoutubeTokenToProducts < ActiveRecord::Migration
  def up
    add_column :products, :youtube_token, :string
  end

  def down
    change_table :youtube_token do |t|
      t.remove  "video_link"
    end
  end
end
