class ChangeSeoTextToPageTitle < ActiveRecord::Migration
  def change
    rename_column :headers, :seo_text, :page_title
  end
end
