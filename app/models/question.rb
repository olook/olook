# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  has_many :answers, :order => '`question_id`, `order`, `id`'
  belongs_to :survey

  scope :from_registration_survey, joins(:survey).where("surveys.name = 'Registration Survey'").includes(:answers)

end
