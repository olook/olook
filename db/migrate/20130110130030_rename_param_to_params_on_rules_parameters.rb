class RenameParamToParamsOnRulesParameters < ActiveRecord::Migration
  def change
    change_table :rules_parameters do |t|
      t.rename :params, :rules_params
    end
  end
end
