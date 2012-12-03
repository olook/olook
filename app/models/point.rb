# == Schema Information
#
# Table name: points
#
#  id         :integer          not null, primary key
#  value      :integer
#  user_id    :integer
#  profile_id :integer
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
class Point < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  delegate :name, to: :profile, prefix: :profile
end
