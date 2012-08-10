class CreateUserCredits < ActiveRecord::Migration
  def change
    create_table :user_credits do |t|
      t.references :credit_type
      t.references :user
      t.decimal :total

      t.timestamps
    end
    add_index :user_credits, :credit_type_id
    add_index :user_credits, :user_id
  end
end
