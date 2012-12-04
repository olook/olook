require 'spec_helper'

describe Survey do
  subject { described_class.create(:name => "A Quiz") }

  describe 'relationships' do
    it { should have_many :questions }
    it { should validate_uniqueness_of(:name) }
  end
end
