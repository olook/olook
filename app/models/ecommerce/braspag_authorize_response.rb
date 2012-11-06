class BraspagAuthorizeResponse < ActiveRecord::Base
  scope :to_process, where(:processed => false).order(:id)
end
