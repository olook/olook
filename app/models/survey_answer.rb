# -*- encoding : utf-8 -*-
class SurveyAnswer < ActiveRecord::Base
  belongs_to :user
  serialize :answers, Hash
end
