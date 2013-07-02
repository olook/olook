class CreateHighlightCampaigns < ActiveRecord::Migration
  def change
    create_table :highlight_campaigns do |t|
      t.string :label

      t.timestamps
    end
  end
end
