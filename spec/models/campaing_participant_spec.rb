# == Schema Information
#
# Table name: campaing_participants
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  gender     :boolean
#  campaing   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
