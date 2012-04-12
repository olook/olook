# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  has_many :answers, :order => '`question_id`, `order`, `id`'
  belongs_to :survey, :dependent => :destroy

  scope :from_registration_survey, joins(:survey).where("surveys.name = 'Registration Survey'").includes(:answers)
  scope :from_gift_survey, joins(:survey).where("surveys.name = 'Gift Survey'").includes(:answers)

end
