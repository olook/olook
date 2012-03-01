class CreateLiquidations < ActiveRecord::Migration
  def change
    create_table :liquidations do |t|
      t.string :name
      t.string :description
      t.string :teaser
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :welcome_banner
      t.string :lightbox_banner

      t.timestamps
    end
  end
end
