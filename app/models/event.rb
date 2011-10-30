# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  has_enumeration_for :type, with: EventType, required: true
end
