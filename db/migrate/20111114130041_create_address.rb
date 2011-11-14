class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :country
      t.string :city
      t.string :state
      t.string :complement
      t.string :street
      t.integer :number
      t.string :neighborhood
      t.string :zip_code
      t.string :telephone
    end
  end
end
