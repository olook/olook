# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserReport do

  describe '#export' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'should generate an array of users suitable to export to text' do
      expected_result = [ user.first_name,
        user.last_name,
        user.email,
        user.is_invited? ? 'invited' : 'organic',
        user.created_at.to_s(:short),
        user.profile_scores.first.try(:profile).try(:name),
        user.invitation_url,
        user.events.where(:event_type => EventType::TRACKING).first.try(:description)
      ]
      described_class.export.should == [ expected_result ]
    end
  end

  describe '#statistics' do
    let(:result_a) { double(:result, creation_date: Date.civil(2011, 11, 15), daily_total: 10 ) }
    let(:result_b) { double(:result, creation_date: Date.civil(2011, 11, 16), daily_total: 13 ) }
    let(:group_result) { [ result_a, result_b ] }

    let(:select_result) do
      select = double :select
      select.stub(:group).with("date(created_at)").and_return(group_result)
      select
    end

    it "should count the users created grouped by date" do
      User.stub(:select).with("date(created_at) as creation_date, count(id) as daily_total").and_return(select_result)
      
      described_class.statistics.should == group_result
    end
  end
end
