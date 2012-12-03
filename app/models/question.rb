# == Schema Information
#
# Table name: questions
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  friend_title :string(255)
#  survey_id    :integer
#

# -*- encoding : utf-8 -*-
class Question < ActiveRecord::Base
  has_many :answers, :order => '`question_id`, `order`, `id`', :dependent => :destroy
  belongs_to :survey, :dependent => :destroy

  scope :from_registration_survey, joins(:survey).where("surveys.name = 'Registration Survey'").includes(:answers)
  scope :from_gift_survey, joins(:survey).where("surveys.name = 'Gift Survey'").includes(:answers)

end
