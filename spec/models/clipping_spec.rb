require 'spec_helper'

describe Clipping do
  describe '#validations' do
    it { should validate_presence_of(:logo) }
    it { should validate_presence_of(:clipping_text) }
    it { should validate_presence_of(:link) }
    it { should validate_presence_of(:published_at) }
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:title) }
  end
end
