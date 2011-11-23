class RenameColumnTypeToEventTypeOnEvents < ActiveRecord::Migration
  def change
    remove_index "events", :name => "index_events_on_type"
    rename_column :events, :type, :event_type
    add_index "events", ["event_type"], :name => "index_events_on_event_type"
  end
end
