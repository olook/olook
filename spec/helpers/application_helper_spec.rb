# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper do
  describe '' do
    it "should return markup for order total" do
     expected = "<span>(<div id=\"cart_items\">0</div>)</span>"
     helper.order_total(nil).should eq(expected)
    end
  end

  describe '#stylesheet_application' do
    it "should" do
      expected = "<link href=\"/assets/application.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />"
      helper.stylesheet_application.should eq(expected)
    end
  end

  describe '#render_google_remessaging_scripts' do
    context 'for a logged in member' do
      it 'should render the member script' do
        helper.stub(:'user_signed_in?').and_return(true)
        helper.should_receive(:render).with('shared/metrics/google/google_remessaging_member')

        helper.render_google_remessaging_scripts
      end
    end

    context 'for a visitor' do
      it 'should render the visitor script' do
        helper.stub(:'user_signed_in?').and_return(false)
        helper.should_receive(:render).with('shared/metrics/google/google_remessaging_visitor')

        helper.render_google_remessaging_scripts
      end
    end
  end

  describe "#track_event" do
    it "returns a track event string with category, action and item" do
      helper.track_event('category','action','item').should == "_gaq.push(['_trackEvent', 'category', 'action', 'item']);"
    end

    context "when no item is passed" do
      it "returns a track event with category and action only" do
        helper.track_event('category','action').should == "_gaq.push(['_trackEvent', 'category', 'action', '']);"
      end
    end
  end

end
