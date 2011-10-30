# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Event do
  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :type }
    it { should validate_presence_of :description }
  end
  
  describe 'relationships' do
    it { should belong_to :user }
  end
end
