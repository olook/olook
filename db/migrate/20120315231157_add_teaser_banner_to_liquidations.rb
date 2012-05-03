class AddTeaserBannerToLiquidations < ActiveRecord::Migration
  def change
    add_column :liquidations, :teaser_banner, :string
  end
end
