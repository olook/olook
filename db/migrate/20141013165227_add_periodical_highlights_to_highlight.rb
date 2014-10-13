class AddPeriodicalHighlightsToHighlight < ActiveRecord::Migration
  def change
    add_column :highlights, :default, :boolean
    add_column :highlights, :start_date, :date
    add_column :highlights, :end_date, :date
    add_column :highlights, :active, :boolean
  end
end
