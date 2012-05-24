class AddReasonToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :reason, :string
  end
end
