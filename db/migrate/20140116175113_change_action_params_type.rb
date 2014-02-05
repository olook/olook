class ChangeActionParamsType < ActiveRecord::Migration
  def up
    change_column :action_parameters, :action_params, :text
  end

  def down
    change_column :action_parameters, :action_params, :string
  end
end
