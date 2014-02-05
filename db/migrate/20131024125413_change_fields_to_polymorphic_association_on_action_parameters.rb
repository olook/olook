class ChangeFieldsToPolymorphicAssociationOnActionParameters < ActiveRecord::Migration
  def up
    change_table :action_parameters do |t|
      t.string :matchable_type
      t.rename :promotion_id, :matchable_id
    end
  end

  def down
    change_table :action_parameters do |t|
      t.remove :matchable_type
      t.rename :matchable_id, :promotion_id
    end
  end
end
