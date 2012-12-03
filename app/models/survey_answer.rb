# == Schema Information
#
# Table name: survey_answers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  answers    :text
#  created_at :datetime
#  updated_at :datetime
#

# -*- encoding : utf-8 -*-
class SurveyAnswer < ActiveRecord::Base
  belongs_to :user
  serialize :answers, Hash
end
