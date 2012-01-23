# -*- encoding: utf-8 -*-
require 'spec_helper'

describe SynchronizationEvent do
  context "validations" do
    it { should validate_presence_of(:name) }

    it 'should raise an exception if a not allowed name is given' do
      expect { FactoryGirl.create(:weird_name_synchronization_event) }.should raise_exception
    end
  end
end

