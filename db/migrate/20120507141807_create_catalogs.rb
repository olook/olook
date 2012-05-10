class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :type
      t.integer :association_id
      t.timestamps
    end
  end
end
