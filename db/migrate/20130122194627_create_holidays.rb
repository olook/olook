class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.datetime :event_time
      t.string :name

      t.timestamps
    end
  end
end
