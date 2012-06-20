require 'spec_helper'

describe CampaingParticipant do
  describe 'set_user_data!' do
    it 'should get all user data' do
      user = FactoryGirl.create(:member)
      participant = described_class.new(:user => user, :campaing => 'foo')
      participant.set_user_data!
      participant.first_name.should == user.first_name
      participant.last_name.should == user.last_name
      participant.gender.should == user.gender
      participant.email.should == user.email
    end
  end

  it 'should call set_user_data! before validation.' do
      user = FactoryGirl.create(:user)
      participant = described_class.new(:user => user, :campaing => 'foo')
      participant.should_receive(:set_user_data!)
      participant.valid?
  end
end
