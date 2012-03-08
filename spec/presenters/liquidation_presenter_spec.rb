# -*- encoding : utf-8 -*-
require "spec_helper"

describe LiquidationPresenter do
  let(:liquidation) { FactoryGirl.create(:liquidation) }
  let(:template) { double :template }
  subject { described_class.new template, :liquidation => liquidation }

  it "should render the search form" do
    template.should_receive(:render).with(:partial => 'liquidations/search_form', :locals => {:liquidation_presenter => subject})
    subject.render_search_form
  end
end


