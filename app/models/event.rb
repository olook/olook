# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base
  require 'event_type'

  belongs_to :user

  validates :user, presence: true
  validates :description, presence: true
  has_enumeration_for :type, with: Type, required: true
end
