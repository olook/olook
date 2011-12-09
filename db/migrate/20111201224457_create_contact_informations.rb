class CreateContactInformations < ActiveRecord::Migration
  def change
    create_table :contact_informations do |t|
      t.string :title
      t.string :email

      t.timestamps
    end
  end
end
