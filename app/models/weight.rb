# -*- encoding : utf-8 -*-
class Weight < ActiveRecord::Base
  belongs_to :answer
  belongs_to :profile
end
