# -*- encoding : utf-8 -*-
class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name

      t.timestamps
    end
  end
end
