class AddDefaultToProccessOnBraspagAuthorizeResponses < ActiveRecord::Migration
  def change
    change_column :braspag_authorize_responses, :processed, :boolean, :default=>0
  end
end
