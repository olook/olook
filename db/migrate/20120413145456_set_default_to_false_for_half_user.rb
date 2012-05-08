class SetDefaultToFalseForHalfUser < ActiveRecord::Migration
  def up
    change_column(:users, :half_user, :boolean, :default => false)
  end

  def down
    change_column(:users, :half_user, :boolean)
  end
end
