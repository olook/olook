class ChangeEventTimeTypeFromHolidays < ActiveRecord::Migration
  def change
    change_column :holidays, :event_time, :date
    rename_column :holidays, :event_time, :event_date
  end
end
