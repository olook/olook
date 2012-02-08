class AddPictureNameToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :picture_name, :string
  end
end
