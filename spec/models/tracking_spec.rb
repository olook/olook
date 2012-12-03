# == Schema Information
#
# Table name: trackings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  utm_source   :string(255)
#  utm_medium   :string(255)
#  utm_content  :string(255)
#  utm_campaign :string(255)
#  gclid        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  placement    :string(255)
#  referer      :string(255)
#

require "spec_helper"

describe Tracking do
  let(:another_day) { Date.today + 2.days }
  let(:day) { Date.today }

  describe "relationships" do
    it { should belong_to :user }
  end
end
