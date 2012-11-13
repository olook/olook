require 'spec_helper'

describe Campaign do
  context "attributes validation" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :start_at }
    it { should validate_presence_of :end_at }
  end
end
