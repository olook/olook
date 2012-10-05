class AddMobileToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :mobile, :string

  end
end
