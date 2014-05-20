class CreateSeoLinks < ActiveRecord::Migration
  def change
    create_table :seo_links do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
