# == Schema Information
#
# Table name: videos
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  url                 :string(255)
#  video_relation_id   :integer
#  video_relation_type :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Video do
  subject { FactoryGirl.create(:video) }

  describe "attributes validation" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:video_relation_id) }
    it { should validate_presence_of(:video_relation_type) }
  end

  describe "relationships" do
    it { should belong_to :video_relation }
  end

end
