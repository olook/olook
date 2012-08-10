class AddFidelidadeRelatedFieldsToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :activates_at, :datetime
    add_column :credits, :expires_at, :datetime
    add_column :credits, :original_credit_id, :integer

    add_index :credits, :activates_at
    add_index :credits, :expires_at
    add_index :credits, :original_credit_id
  end
end
