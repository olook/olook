class RenameTableRulesParameters < ActiveRecord::Migration
  def change
    rename_table :rules_parameters, :rule_parameters
  end
end
