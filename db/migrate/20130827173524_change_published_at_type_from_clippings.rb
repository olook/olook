class ChangePublishedAtTypeFromClippings < ActiveRecord::Migration
  def change
    change_column :clippings, :published_at, :date
  end
end
