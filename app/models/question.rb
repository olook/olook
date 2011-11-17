# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  has_many :answers, :order => '`question_id`, `order`, `id`'
end
