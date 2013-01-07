class AddUseCreditsToCart < ActiveRecord::Migration
  def change
    add_column :carts, :use_credits, :boolean, default: false

  end
end
