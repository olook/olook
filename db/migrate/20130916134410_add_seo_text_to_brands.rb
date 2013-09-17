class AddSeoTextToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :seo_text, :string
  end
end
