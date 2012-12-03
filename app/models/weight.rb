# == Schema Information
#
# Table name: weights
#
#  id         :integer          not null, primary key
#  profile_id :integer
#  answer_id  :integer
#  weight     :integer
#

# -*- encoding : utf-8 -*-
class Weight < ActiveRecord::Base
  belongs_to :answer
  belongs_to :profile
end
