class AddIndexOnActionParameters < ActiveRecord::Migration
  def up
    add_index :action_parameters, [:matchable_id, :matchable_type]
    add_index :rule_parameters, [:matchable_id, :matchable_type]
  end

  def down
    remove_index :action_parameters, [:matchable_id, :matchable_type]
    remove_index :rule_parameters, [:matchable_id, :matchable_type]
  end
end
