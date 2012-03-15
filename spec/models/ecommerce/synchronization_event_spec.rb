# -*- encoding: utf-8 -*-
require 'spec_helper'

describe SynchronizationEvent do
  before do
    Resque.stub(:enqueue)
  end

  context "validations" do
    it { should validate_presence_of(:name) }

    it 'should raise an exception if a not allowed name is given' do
      expect { FactoryGirl.create(:weird_name_synchronization_event) }.should raise_exception
    end

    it 'should raise an exception if an event was created less than 10 minutes before' do
      FactoryGirl.create(:locked_synchronization_event)
      expect { FactoryGirl.create(:locked_synchronization_event) }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

