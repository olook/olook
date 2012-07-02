# -*- encoding : utf-8 -*-
require "spec_helper"
require "rake"

describe 'rake order:send_billet_reminder' do
  before do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/billet_reminder"
    Rake::Task.define_task(:environment)
  end

  it "should send a reminder email" do
    user = FactoryGirl.create(:user)
    order = FactoryGirl.create(:order, :user => user)
    billet = FactoryGirl.create(:billet, :order => order, :created_at => Date.yesterday)

    ActionMailer::Base.deliveries.count.should == 0
    @rake['order:send_billet_reminder'].invoke
    ActionMailer::Base.deliveries.count.should == 1
  end
end
