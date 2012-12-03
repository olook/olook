# == Schema Information
#
# Table name: user_liquidations
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  liquidation_id         :integer
#  dont_want_to_see_again :boolean          default(FALSE)
#  created_at             :datetime
#  updated_at             :datetime
#

class UserLiquidation < ActiveRecord::Base
  belongs_to :user
  belongs_to :liquidation
end
