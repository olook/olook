# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Collection do
  subject { FactoryGirl.create :collection }

  describe 'validations' do
    it { should have_many(:products) }

    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end
end
