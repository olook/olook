# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  event_type  :integer          not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  has_enumeration_for :event_type, with: EventType, required: true
end
