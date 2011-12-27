# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserReport do
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
