class CreateCreditTypes < ActiveRecord::Migration
  def change
    create_table :credit_types do |t|
      t.string :type

      t.timestamps
    end
  end
end
