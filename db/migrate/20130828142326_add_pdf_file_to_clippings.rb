class AddPdfFileToClippings < ActiveRecord::Migration
  def change
    add_column :clippings, :pdf_file, :string
  end
end
