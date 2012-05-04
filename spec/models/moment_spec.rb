require 'spec_helper'

describe Moment do
  let(:moment) { Factory.create(:moment) }
  
  describe "validation" do
    it { should validate_presence_of(:name) }
    it { moment.should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:slug) }
    it { moment.should validate_uniqueness_of(:slug) }
  end
end
