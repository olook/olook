# -*- encoding : utf-8 -*-
class Point < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  delegate :name, to: :profile, prefix: :profile
end
