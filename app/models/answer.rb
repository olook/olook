# == Schema Information
#
# Table name: answers
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  question_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#  order        :integer
#  picture_name :string(255)
#

# -*- encoding : utf-8 -*-
class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :weights
  has_many :profiles, :through => :weights
end
