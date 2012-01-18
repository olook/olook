# -*- encoding: utf-8 -*-
require 'spec_helper'

#let(:unlocked_event) { FactoryGirl.create(:unlocked_sync_event) }

describe SynchronizationEvent do
  context "validations" do
    it { should validate_presence_of(:name) }
  end

  it 'should return true when a event was created less than 10 minutes ago' do
    event = FactoryGirl.create(:lockedsyncevent)
    SynchronizationEvent.locked?
  end
end

