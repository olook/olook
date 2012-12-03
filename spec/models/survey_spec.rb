# == Schema Information
#
# Table name: surveys
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Survey do
  subject { described_class.create(:name => "A Quiz") }

  describe 'relationships' do
    it { should have_many :questions }
    it { should validate_uniqueness_of(:name) }
  end
end
