require 'spec_helper'

describe Admin::UserCreditsController do
  describe 'GET index' do
    it "should assigns users"
    it "should assigns uses ordered by amount of credit"
  end

  describe 'GET users_filtered_by_credit_type' do
    it "should assings users filtered by a range of credits amount"
    it "should assings users filtered by a range of date"
  end
end