class AddRetriesToBraspagAuthorizeResponse < ActiveRecord::Migration
  def change
    add_column :braspag_authorize_responses, :retries, :integer, :default => 0

  end
end
