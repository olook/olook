# == Schema Information
#
# Table name: trackings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  utm_source   :string(255)
#  utm_medium   :string(255)
#  utm_content  :string(255)
#  utm_campaign :string(255)
#  gclid        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  placement    :string(255)
#  referer      :string(255)
#

# -*- encoding : utf-8 -*-
class Tracking < ActiveRecord::Base
  belongs_to :user

  def clean_placement
    placement.delete(",") if placement
  end

end
