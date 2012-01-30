class AddFirstNameAndLastNameToAdmin < ActiveRecord::Migration
  def change
  	change_table(:admins) do |admin|
      admin.column :first_name, :string
      admin.column :last_name,	:string
    end
  end
end
