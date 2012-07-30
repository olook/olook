class AddRefererToTrackings < ActiveRecord::Migration
  def change
    add_column :trackings, :referer, :string

  end
end
