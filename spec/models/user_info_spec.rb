# == Schema Information
#
# Table name: user_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  shoes_size :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe UserInfo do
    describe "validation" do
    it { should belong_to(:user) }
  end
end
