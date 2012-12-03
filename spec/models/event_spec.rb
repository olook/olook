# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  event_type  :integer          not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Event do
  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :event_type }
  end
  
  describe 'relationships' do
    it { should belong_to :user }
  end
end
