class AddFriendTitleToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :friend_title, :string
  end
end
