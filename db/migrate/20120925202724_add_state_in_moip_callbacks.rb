class AddStateInMoipCallbacks < ActiveRecord::Migration
  def up
    add_column :moip_callbacks, :processed, :boolean
    MoipCallback.update_all(:processed => true)
  end

  def down
    remove_column :moip_callbacks, :processed
  end
end