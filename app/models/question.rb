# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  has_many :answers

end
