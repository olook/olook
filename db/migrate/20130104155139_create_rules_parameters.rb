class CreateRulesParameters < ActiveRecord::Migration
  def change
    create_table :rules_parameters do |t|
      t.text :params
      t.integer :promotion_rule_id
      t.integer :promotion_id

      t.timestamps
    end
  end
end
