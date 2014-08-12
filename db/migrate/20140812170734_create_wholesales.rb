class CreateWholesales < ActiveRecord::Migration
  def change
    create_table :wholesales do |t|

      t.timestamps
    end
  end
end
