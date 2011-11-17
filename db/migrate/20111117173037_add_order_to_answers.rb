class AddOrderToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :order, :integer
  end
end
