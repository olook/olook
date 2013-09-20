class CreateClippings < ActiveRecord::Migration
  def change
    create_table :clippings do |t|
      t.string :logo
      t.string :title
      t.string :clipping_text
      t.string :published_at
      t.string :source
      t.string :link

      t.timestamps
    end
  end
end
