class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.date :start_at
      t.date :end_at
      t.string :lightbox
      t.string :banner
      t.string :background

      t.timestamps
    end
  end
end
