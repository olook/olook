# -*- encoding : utf-8 -*-
require 'spec_helper'

describe BilletNotifier do
  let(:date){ Time.new(2012,11,12) } # it's a Monday.

  describe '.last_day_billets' do
    it 'should return a range from the beginning to the end of the prev day' do
      described_class.last_day_billets(date+1.day).should == {:created_at => date..date.end_of_day, :reminder_sent => false }
    end

    it 'should return the entire weekend when checking for a monday' do
      described_class.last_day_billets(date).should == {:created_at => date-3.days..(date-1.day).end_of_day, :reminder_sent => false }
    end
  end

  describe '.send_reminder' do
    let!(:billet) { FactoryGirl.create(:billet, :created_at => Time.new(2012,11,12,1,0,0))  }

    before :each do
      date = Time.new(2012,11,12,1,0,0)
      described_class.should_receive(:last_day_billets).and_return({:created_at => date.beginning_of_day..date.end_of_day, :reminder_sent => false})
    end

    context 'when there is a reminder to be sent' do
      before :each do
        BilletMailer.should_receive(:send_reminder_mail)
      end

      it 'should set reminder_sent for true' do
        billet.reminder_sent.should be_false
        described_class.send_reminder
        billet.reload.reminder_sent.should be_true
      end

      it 'should return a list of objects responding to deliver' do
        described_class.send_reminder.first.respond_to?(:deliver)
      end
    end

    it 'should not return a billet if reminder_sent is true' do
      billet.update_attribute(:reminder_sent, true)
      described_class.send_reminder.should be_empty
    end
  end
end
