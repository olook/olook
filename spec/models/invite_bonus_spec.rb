# -*- encoding : utf-8 -*-
require 'spec_helper'

describe InviteBonus do
  describe "when calculating the invite bonus" do
    let(:member) { FactoryGirl.create(:member) }

    describe "#for_being_invited" do
      it "should be R$ 10 for invited members" do
        member.stub(:'is_invited?').and_return(true)
        described_class.for_being_invited(member).should == 10.0
      end
      it "should be R$ 0 for uninvited members" do
        member.stub(:'is_invited?').and_return(false)
        described_class.for_being_invited(member).should == 0.0
      end
    end
    
    describe "#for_accepted_invites, when a user has 20 invites, 13 of which were accepted" do
      context "for invites accepted before 10th Nov 2011" do
        before :each do
          build_invites( DateTime.civil(2011, 11, 9, 9, 59, 59) )
        end

        it "should be R$ 10 for each accepted invitation, in this case R$ 130" do
          described_class.for_accepted_invites(member).should == 130.0
        end
      end

      context "invites accepted between 10th Nov 2011 and 20th Nov 2011" do
        before :each do
          build_invites( DateTime.civil(2011, 11, 10, 10, 0, 0) )
        end

        it "should be R$ 20 for every 5 accepted invitations, in this case R$ 40" do
          described_class.for_accepted_invites(member).should == 40.0
        end
      end
    end
    
    describe "#calculate" do
      it "should be the sum of for_accepted_invites and for_being_invited" do
        described_class.stub(:for_accepted_invites).and_return(123.0)
        described_class.stub(:for_being_invited).and_return(7.0)
        described_class.calculate(member).should == 130.0
      end
      it 'should be limited to R$ 300 no matter how many invites were accepted' do
        described_class.stub(:for_accepted_invites).and_return(10000000.0)
        described_class.calculate(member).should == 300.0
      end
    end
  end

private  
  def build_invites(accepted_at)
    # Accepted invites
    13.times do
      accepting_member = FactoryGirl.create(:member, :first_name => 'Accepting member')
      FactoryGirl.create(:sent_invite, :user => member, :invited_member => accepting_member, :accepted_at => accepted_at, :resubmitted => nil)
    end

    # Unaccepted invites
    7.times do
      FactoryGirl.create(:sent_invite, :user => member )
    end
  end
end
