class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :controller_name
      t.string :description

      t.timestamps
    end
  end
end
