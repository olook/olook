# -*- encoding: utf-8 -*-
require 'spec_helper'

describe SynchronizationEvent do
  context "validations" do
    it { should validate_presence_of(:name) }

    it 'should raise an exception if a not allowed name is given' do
      expect { FactoryGirl.create(:weird_name_synchronization_event) }.should raise_exception
    end
  end

  context "#locked?" do
    it 'should return true when an event was created less than 10 minutes ago' do
      sync_event = FactoryGirl.create(:locked_synchronization_event)
      SynchronizationEvent.locked?.should be_true
    end
  
    it 'should return false when an event was created more than 10 minutes ago' do
      sync_event = FactoryGirl.create(:unlocked_synchronization_event)
      SynchronizationEvent.locked?.should be_false
    end
  end
end

