class RemoveProfileFromAsnwers < ActiveRecord::Migration
  def change
    remove_column :answers, :profile_id
  end
end
