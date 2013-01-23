class RenameParamToParamsOnActionParameters < ActiveRecord::Migration
  def change
    change_table :action_parameters do |t|
      t.rename :param, :action_params
    end
  end
end
