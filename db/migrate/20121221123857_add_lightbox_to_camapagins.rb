class AddLightboxToCamapagins < ActiveRecord::Migration
  def change
    add_column :campaigns, :lightbox, :string

  end
end
