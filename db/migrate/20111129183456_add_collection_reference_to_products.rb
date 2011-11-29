class AddCollectionReferenceToProducts < ActiveRecord::Migration
  def change
    add_index :collections, :start_date
    add_index :collections, :end_date

    add_column :products, :collection_id, :integer
    add_index :products, :collection_id
  end
end
